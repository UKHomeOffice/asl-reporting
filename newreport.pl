#! /usr/local/bin/perl
use strict;
use warnings;
use Cwd;
use lib cwd;
use ReportConsts;
use Selenium::Remote::Driver;
use Selenium::Chrome;
use Selenium::Remote::WDKeys;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "copy";
use TestASL;
use TestBits;

## Constants
my $TEMPLATE='REPORT_TEMPLATE.md';

my $offset = shift // 'today';
(my $date_short = `date --date \'$offset\' +%d%m%Y`)  =~ s/\n//g;
## get the date in jira format for last week
(my $date_jira_seconds = `date --date \'$offset\' +%s`)  =~ s/\n//g;
$date_jira_seconds = $date_jira_seconds - (60*60*24*7);
(my $date_jira_format = `date -d \'\@$date_jira_seconds\' +%Y-%m-%d`) =~s/\n//g;
(my $date_long = `date --date \'$offset\' "+%A %d %B %Y"`) =~ s/\n//g;
(my $date_for_seconds = `date --date \'$offset\' +%Y%m%d`)  =~ s/\n//g;
(my $start_seconds = `date --date "20180207" +%s`) =~ s/\n//g;
(my $end_seconds = `date --date \"$date_long\" +%s`) =~ s/\n//g;
my $sprint =  int((int($end_seconds) - int($start_seconds))/(60*60*24*14));
my $report_file = "report$date_short.md";

copy($TEMPLATE,$report_file) or die "Copy failed: $!";

my $file = path($report_file);
my $data = $file->slurp_utf8;
$data =~ s/DATE_SHORT/$date_short/g;
$data =~ s/DATE_LONG/$date_long/g;
$data =~ s/SPRINT_NO/$sprint/g;
$file->spew_utf8( $data );

## get the jira screenshots
my $bash_command = "bash getscreenshot.sh \'$SPRINT_STORIES\'";
say $bash_command;
## stories in the sprint
`$bash_command`;
$SPRINT_FILE =~ s/DATE_SHORT/$date_short/g;
copy ($OUTPUT_FILE, $SPRINT_FILE);
$RECENT_BUGS =~ s/JIRA_DATE_FORMAT/$date_jira_format/;

## bugs fixed in the sprint
$BUGS_FILE =~ s/DATE_SHORT/$date_short/g;
$bash_command = "bash getscreenshot.sh \'$RECENT_BUGS\'";
say $bash_command;
`$bash_command`;
copy ($OUTPUT_FILE, $BUGS_FILE);

my $username = shift || die "No username";
my $password = shift || die "No password";

my $driver = Selenium::Chrome->new;
$driver->get("https://jira.digital.homeoffice.gov.uk/");
login($driver,  $username, $password);
$driver->pause(5000);
$driver->get($TODO);
$driver->pause(5000);
my $element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
my $todo =  $element->get_text();
$driver->pause(5000);
$driver->get($DOING);
$driver->pause(5000);
my $element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
my $doing = $element->get_text();
$driver->get($DONE);
$driver->pause(5000);
my $element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
my $done = $element->get_text();
open(my $fh, '>>', $PROGRESS_DAT_FILE) or die "Could not open file '$PROGRESS_DAT_FILE' $!";
say $fh "$date_for_seconds $done $doing $todo";
close $fh;
chdir 'graphs';
$bash_command = "gnuplot $PROGRESS_GNU_FILE";
`$bash_command`;
$PROGRESS_FILE =~ s/DATE_SHORT/$date_short/g;
copy ($PROGRESS_OUTPUT_FILE, $PROGRESS_FILE);
chdir '..';
`pwd`;

## look for the Analytics file
`touch ~/Downloads/timestamp -d $date_jira_format`;
(my $analytics_file = `find ~/Downloads -newer ~/Downloads/timestamp | grep Analytics | grep pdf`)=~ s/\n//g || die "No recent Analytics file";
say $analytics_file;
