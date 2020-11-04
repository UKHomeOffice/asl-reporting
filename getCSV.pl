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

my $username = shift || die "No username";
my $password = shift || die "No password";

my $driver = Selenium::Chrome->new;
$driver->get("https://jira.digital.homeoffice.gov.uk/");
login($driver,  $username, $password);
$driver->pause(5000);
$driver->get('https://jira.digital.homeoffice.gov.uk/sr/jira.issueviews:searchrequest-csv-all-fields/temp/SearchRequest.csv?jqlQuery=project+%3D+%22AS%22++and+issuekey+%3C+AS-1000');
$driver->pause(5000);
$driver->get('https://jira.digital.homeoffice.gov.uk/sr/jira.issueviews:searchrequest-csv-all-fields/temp/SearchRequest.csv?jqlQuery=project+%3D+%22AS%22+and+issuekey%3E%3DAS-1000+and+issuekey+%3C+AS-2000');
$driver->pause(5000);
$driver->get('https://jira.digital.homeoffice.gov.uk/sr/jira.issueviews:searchrequest-csv-all-fields/temp/SearchRequest.csv?jqlQuery=project+%3D+%22AS%22++and+issuekey+%3E%3D+AS-2000');
$driver->pause(5000);

