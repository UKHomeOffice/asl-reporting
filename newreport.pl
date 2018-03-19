use strict;
use warnings;
use 5.010;
use Path::Tiny qw(path);
$ENV{MOZ_DISABLE_AUTO_SAFE_MODE} = '1'; 

my @st_nd_rd_th= ("th","st", "nd", "rd", "th", "th", "th", "th", "th", "th");
my@monthText = ("January", "February","March", "April", "May", "June", "July", "August", "September", "October", "November", "December");

my $TEMPLATE_FILE = "templateReport.md";
my $REPORT_NAME = "reportRRR_DATE.md";
my $index = "index.md";
my $GRAPH_DIR = "graphs/";
my @urls;
my @files;
my $progress = "progressXXXDATEXXX.png";
my $progressOut = "progress.png";
my $risk = "riskXXXDATEXXX.png";
my $riskOut = "risk.png";
my $sprint = "sprintXXXDATEXXX";
my $roadmap = "ASLRoadMapXXXDATEXXX";
my $riskRegister = "ASLRiskRegisterXXXDATEXXX";
my $riskData = "risk.dat";
my $progressData = "progress.dat";
my $riskGnu = "risk.gnu";
my $progressGnu = "progress.gnu";

push @urls, "https://jira.digital.homeoffice.gov.uk/secure/RapidBoard.jspa?rapidView=261";
push @files, "$sprint";
push @urls,"https://trello.com/b/gDQdE01u/asl-roadmap";
push @files, "$roadmap";
push @urls, "https://trello.com/b/VuFuCL7t/risk-register-and-kpis-asl-delivery";
push @files, "$riskRegister";


my $date = shift;
$date || die "Sorry no date provided";
my $day;
my $month;
my $year;
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
	system("sleep 5");
	system("gnome-screenshot -B -w *firefox* -f $GRAPH_DIR$fileFragment.jpg");
}

system ("pkill -f firefox");

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
## muck around with the index file
system("cp $index $index.bak");

$filename = $index;
$file = path($filename);
$data = $file->slurp_utf8;
$data =~ s/##\s+/## [Report $humanDate]($REPORT_NAME)\n\n/g;
$file->spew_utf8( $data );

print "All the automated stuff is done - now you just need to add the content\n";

#
#
#
#
