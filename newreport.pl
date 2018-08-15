use strict;
use warnings;
use Cwd;
use lib cwd;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "cp";
use Days;

$ENV{MOZ_DISABLE_AUTO_SAFE_MODE} = '1'; 

my @st_nd_rd_th= ("th","st", "nd", "rd", "th", "th", "th", "th", "th", "th");
my@monthText = ("January", "February","March", "April", "May", "June", "July", "August", "September", "October", "November", "December");

my $TEMPLATE_FILE = "templateReport.md";
my $REPORT_NAME = "reportRRR_DATE.md";
my $index = "index.md";
my $GRAPH_DIR = "graphs/";
my $SCREENSHOT_DIR = "../scrsht/screenshots/";
my $screenshot = "url.png";
my @urls;
my @files;
my @urls_js; #urls that we'll take the screenshot using a javascript program
my @files_js; #ditto for files
my $progress = "progressXXXDATEXXX.png";
my $progressOut = "progress.png";
my $burnup = "burnupXXXDATEXXX.svg";
my $burnupOut = 'file.svg';
my $risk = "riskXXXDATEXXX.png";
my $riskOut = "risk.png";
my $sprint = "sprintXXXDATEXXX";
my $roadmap = "ASLRoadMapXXXDATEXXX";
my $riskRegister = "ASLRiskRegisterXXXDATEXXX";
my $riskData = "risk.dat";
my $progressData = "progress.dat";
my $riskGnu = "risk.gnu";
my $progressGnu = "progress.gnu";

# get the screenshot of the tickets in the sprint 
my $screenshotURL = "\"https://jira.digital.homeoffice.gov.uk/issues/?jql=Project%20%3D%20%22Animal%20Sciences%22%20AND%20Sprint%20in%20openSprints()%20ORDER%20BY%20status%20DESC\"";

push @urls_js, "$screenshotURL";
push @files_js, "$sprint";
push @urls,"https://trello.com/b/gDQdE01u/asl-roadmap";
push @files, "$roadmap";
push @urls, "https://trello.com/b/VuFuCL7t/risk-register-and-kpis-asl-delivery";
push @files, "$riskRegister";


my $date = shift;
my $flags = shift;

$date || die "Sorry no date provided";
my $day;
my $month;
my $year;

my $dayCount = numberOfDaysIncremental("07022018", "$date");

print "Number of days since project started = ".$dayCount;
print "Weeks since project started = ".($dayCount/7);
print "Fortnights since project started = ". ($dayCount/14);
print "So the sprint number is".(($dayCount/14)+1);
my $sprintNumber = ($dayCount/14)+1;
my $roundedSprintNumber = int $sprintNumber;
my $midSprint = !($sprintNumber == $roundedSprintNumber);
my $midSprintString = "";
if($midSprint)
{
	$midSprintString = " - mid-sprint";
}

print "Mid sprint string is: $midSprintString";

$date =~ /(\d\d)(\d\d)(\d\d\d\d)/ || die "Invalid date format";
$day = $1;
$month = $2;
$year = $3;
($day >= 1 && $day <=31) || die "Invalid day of month";
($month >= 1 && $month <=12) || die "Invalid month";
($year >2017 && $year < 2050) || die "Invalid year";
my $dayAdd;
if ($day <4 || $day > 20)
{
	$dayAdd = $day%10;
}
else
{
	$dayAdd = 4; #th
}

my $singleDay = $day; 
$singleDay =~ s/^0+//g;
my $humanDate = $singleDay.$st_nd_rd_th[$dayAdd]." ".$monthText[$month-1]." ".$year;


print "Human Date is $humanDate\n";
if ($flags  =~ /.*s.*/)
{goto SCREENSHOT;}

##copy the template to a new file with the new date
$REPORT_NAME =~ s/RRR_DATE/$day$month$year/;
if(-e $REPORT_NAME)
{
    print "File already exists\n";
}
else
{   print "Creating File $REPORT_NAME\n";
    system "cp $TEMPLATE_FILE $REPORT_NAME" || die "Failed to copy template file";
}

## open the new file
my $filename = $REPORT_NAME;
my $file = path($filename);
my $data = $file->slurp_utf8;
$data =~ s/RRRDATE_SHORT/$day$month$year/g;
$data =~ s/RRRDATE_LONG/$humanDate/g;
$file->spew_utf8( $data );

system ("pkill -f firefox");

while (my $link = pop @urls)
{
	my $fileFragment = pop @files;
	$fileFragment =~ s/XXXDATEXXX/$day$month$year/g;

system ("firefox $link&");
system("sleep 15");
system("gnome-screenshot -B -w *firefox* -f $GRAPH_DIR$fileFragment.jpg");
		
}

system ("pkill -f firefox");

SCREENSHOT:
## get the screenshot of the tickets in the sprint
my $local_url = pop @urls_js; 
my $local_file = pop @files_js;
$local_file =~ s/XXXDATEXXX/$day$month$year/g;

system ("bash getscreenshot.sh $screenshotURL");

-e "$SCREENSHOT_DIR$screenshot" or die "Screenshot file doesn't exist.";

cp("$SCREENSHOT_DIR$screenshot", "$GRAPH_DIR$local_file.png") || die "file copy failed";

## run the script that gets the diagrams
## stop if there isn't a data entry in the .dat file for the date that's given
chdir ("graphs");
$filename = $riskData;
$file = path($filename);
$data = $file->slurp_utf8;
($data =~ /$day\/$month\/$year/g) || die "Data file $riskData isn't up to date.";
system("gnuplot $riskGnu");
$risk =~ s/XXXDATEXXX/$day$month$year/g;
system("cp $riskOut $risk");

$filename = $progressData;
$file = path($filename);
$data = $file->slurp_utf8;
($data =~ /$day\/$month\/$year/g) || die "Data file $progressData isn't up to date.";
system("gnuplot $progressGnu");
$progress =~ s/XXXDATEXXX/$day$month$year/g;
system("cp $progressOut $progress");

chdir ("..");

system("bash getBurnupData.sh");
$burnup =~ s/XXXDATEXXX/$day$month$year/g;
system("cp $burnupOut $GRAPH_DIR$burnup");

## muck around with the index file
system("cp $index $index.bak");


$filename = $index;
$file = path($filename);
$data = $file->slurp_utf8;
$data =~ s/##\s+/## [Report $humanDate - Sprint $roundedSprintNumber $midSprintString]($REPORT_NAME)\n\n/g;
$file->spew_utf8( $data );

print "All the automated stuff is done - now you just need to add the content\n";

#
#
#
#
