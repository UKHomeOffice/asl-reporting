#! /usr/local/bin/perl
use strict;
use warnings;
use Cwd;
use lib cwd;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "copy";
use Days;

## Constants
my $TEMPLATE='REPORT_TEMPLATE.md';

(my $date_short = `date +%d%m%Y`)  =~ s/\n//g;
(my $date_long = `date "+%A %d %B %Y"`) =~ s/\n//g;

my $report_file = "report$date_short.md";

copy($TEMPLATE,$report_file) or die "Copy failed: $!";

my $file = path($report_file);
my $data = $file->slurp_utf8;
$data =~ s/DATE_SHORT/$date_short/g;
$data =~ s/DATE_LONG/$date_long/g;
$file->spew_utf8( $data );


my $dayCount = numberOfDaysIncremental("07022018", "$date");
my $sprintNumber = ($dayCount/14);
my $roundedSprintNumber = int $sprintNumber;
my $midSprint = !($sprintNumber == $roundedSprintNumber);
my $midSprintString = "";
if($midSprint)
{
        $midSprintString = " - mid-sprint";
}

#
#
#
#
