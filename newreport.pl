use strict;
use warnings;
use 5.010;
use Path::Tiny qw(path);
my $TEMPLATE_FILE = "templateReport.md";
my $REPORT_NAME = "reportRRR_DATE.md";

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
$file->spew_utf8( $data );


