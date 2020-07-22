#! /usr/local/bin/perl
use strict;
use warnings;
use Cwd;
use lib cwd;
use Selenium::Remote::Driver;
use Selenium::Chrome;
use Selenium::Firefox;
use Selenium::Remote::WDKeys;

use Data::Dumper;
use YAML::XS 'LoadFile';
    
use 5.010;
use Path::Tiny qw(path);
use File::Copy "copy";
use TestASL;
use TestBits;
use Screenshot;
use UtilSubs;

my $offset = shift // 'today';

my $sprint = sprint ($offset);

my $username = shift || die "No username";
my $password = shift || die "No password";

(my $date_short = `date --date \'$offset\' +%d%m%Y`)  =~ s/\n//g;
## get the date in jira format for last week
(my $date_jira_seconds = `date --date \'$offset\' +%s`)  =~ s/\n//g;
$date_jira_seconds = $date_jira_seconds - (60*60*24*7);
(my $date_jira_format = `date -d \'\@$date_jira_seconds\' +%Y-%m-%d`) =~s/\n//g;
(my $date_long = `date --date \'$offset\' "+%A %d %B %Y"`) =~ s/\n//g;
(my $date_for_seconds = `date --date \'$offset\' +%Y%m%d`)  =~ s/\n//g;
(my $start_seconds = `date --date "20180207" +%s`) =~ s/\n//g;
(my $end_seconds = `date --date \"$date_long\" +%s`) =~ s/\n//g;
my $report_file = "report$date_short.md";

copy($TEMPLATE,$report_file) or die "Copy failed: $!";


my $bash_command;
## get the jira screenshot
my $driver = Selenium::Firefox->new;
##goto TRELLO;
screenshot($driver, $JIRA_BASE, $SPRINT_STORIES, $username, $password);

$SPRINT_FILE =~ s/DATE_SHORT/$date_short/g;
copy ($OUTPUT_FILE, $SPRINT_FILE);
$driver->close();
$driver = Selenium::Firefox->new;
screenshot($driver, $JIRA_BASE, $SPRINT_STORIES_2, $username, $password);
$SPRINT_FILE_2 =~ s/DATE_SHORT/$date_short/g;
copy ($OUTPUT_FILE, $SPRINT_FILE_2);

$bash_command  = "convert $SPRINT_FILE $SPRINT_FILE_2 -append $OUTPUT_FILE";

say $bash_command;
`$bash_command`;

copy ($OUTPUT_FILE, $SPRINT_FILE);
$driver->close();


$RECENT_BUGS =~ s/JIRA_DATE_FORMAT/$date_jira_format/;
$driver = Selenium::Firefox->new;
screenshot($driver, $JIRA_BASE, $RECENT_BUGS, $username, $password);
$BUGS_FILE =~ s/DATE_SHORT/$date_short/g;
copy ($OUTPUT_FILE, $BUGS_FILE);
$driver->close();

## get the jira screenshot
$driver = Selenium::Firefox->new;
screenshot($driver, $BOARD_BASE, $BOARD, $username, $password);

$BOARD_FILE =~ s/DATE_SHORT/$date_short/g;
copy ($OUTPUT_FILE, $BOARD_FILE);
$driver->close();

TRELLO:
$driver = Selenium::Firefox->new;
$driver->fullscreen_window();
$driver->get($TRELLO_BASE);
login($driver, $TRELLO_USERNAME, $TRELLO_PASSWORD, $TRELLO_LOGIN_XPATH, $TRELLO_PASSWORD_XPATH);
clickOnThing($driver, '//input[@id=\'login\']', 'xpath');
$driver->pause(5000);
clickOnThing($driver, '//input[@id=\'password\']', 'xpath');
replaceTextInThing($driver, $TRELLO_PASSWORD);
$driver->pause(5000);
clickOnThing($driver, '//button[@id=\'login-submit\']', 'xpath');
$TRELLO_FILE =~ s/DATE_SHORT/$date_short/g;
$driver->pause(10000);
$driver->get($TRELLO_ROADMAP);
$driver->pause(500);
$driver->capture_screenshot($OUTPUT_FILE, {'full' => 1});
$driver->pause(5000);
copy ($OUTPUT_FILE, $TRELLO_FILE);

$driver->close();

$driver = Selenium::Chrome->new;
$driver->get($JIRA_BASE);
login($driver, $username, $password);
$driver->pause(5000);
$driver->get($TODO);
$driver->pause(5000);
my $element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
my $todo =  $element->get_text();
$driver->pause(5000);
$driver->get($DOING);
$driver->pause(5000);
$element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
my $doing = $element->get_text();
$driver->get($DONE);
$driver->pause(5000);
$element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
my $done = $element->get_text();


## get the current spring goals
$driver->pause(5000);
$driver->get('https://collaboration.homeoffice.gov.uk/jira/secure/RapidBoard.jspa?rapidView=1706');
$element=  $driver->find_element('//span[@id=\'ghx-sprint-goal\']');
my $currentGoals = $element->get_text();
$currentGoals =~ s/(\d)\)/\n$1./g;
$currentGoals = "## These are the goals for the current sprint:\n".$currentGoals;
say "Current goals are: ".$currentGoals;

## get the previous sprint goals
$driver->pause(5000);
$driver->get('https://collaboration.homeoffice.gov.uk/jira/secure/RapidBoard.jspa?rapidView=1706&view=reporting&chart=sprintRetrospective');
$driver->pause(5000);
$element=  $driver->find_element('//div[@class=\'ghx-sprint-goal\']');
my $previousGoals = $element->get_text();
$previousGoals =~ s/(\d)\)/\n$1./g;
$previousGoals = "## These were the goals for the previous sprint:\n".$previousGoals;
say "Previous goals are: ".$previousGoals;


copy($TEMPLATE,$report_file) or die "Copy failed: $!";
my $file = path($report_file);
my $data = $file->slurp_utf8;
$data =~ s/DATE_SHORT/$date_short/g;
$data =~ s/DATE_LONG/$date_long/g;
$data =~ s/SPRINT_NO/$sprint/g;
$data =~ s/CURRENT_SPRINT_GOALS/$currentGoals/g;
$data =~ s/PREVIOUS_SPRINT_GOALS/$previousGoals/g;

$file->spew_utf8( $data );

## write them in the report 

open(my $fh, '>>', $PROGRESS_DAT_FILE) or die "Could not open file '$PROGRESS_DAT_FILE' $!";
say $fh "$date_for_seconds $done $doing $todo";
close $fh;
chdir 'graphs';
$bash_command = "gnuplot $PROGRESS_GNU_FILE";
`$bash_command`;
$PROGRESS_FILE =~ s/DATE_SHORT/$date_short/g;
copy ($PROGRESS_OUTPUT_FILE, $PROGRESS_FILE);
##chdir '..';
##`pwd`;
##`./newburn.sh`;
##$GA_FILE =~ s/DATE_SHORT/$date_short/g;
##copy ($GA_OUTPUT_FILE, $GA_FILE);
