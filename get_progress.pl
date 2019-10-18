#! /usr/local/bin/perl
use strict;
use warnings;
use Cwd;
use lib cwd;
use Selenium::Remote::Driver;
use Selenium::Chrome;
use Selenium::Remote::WDKeys;
use File::Slurp;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "cp";
use TestASL;
use TestBits;

my $username = shift || die "No username";
my $password = shift || die "No password";

my $driver = Selenium::Chrome->new;
# when you're done
$driver->get("https://jira.digital.homeoffice.gov.uk/");
login($driver,  $username, $password);
$driver->pause(5000);
$driver->get("https://jira.digital.homeoffice.gov.uk/issues/?jql=Project%20%3D%20%22Animal%20Sciences%22%20and%20status%20not%20in%20(%22In%20Progress%22%2C%20Done%2C%20Cancelled%2C%20Archived)%20and%20labels%20!%3D%20%22Risk%22&startIndex=50");
$driver->pause(5000);
my $element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
say $element->get_text();
$driver->pause(5000);
$driver->get("https://jira.digital.homeoffice.gov.uk/issues/?jql=Project%20%3D%20%22Animal%20Sciences%22%20and%20status%20in%20(%22In%20Progress%22)%20and%20labels%20!%3D%20%22Risk%22");
$driver->pause(5000);
my $element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
say $element->get_text();
$driver->get("https://jira.digital.homeoffice.gov.uk/issues/?jql=Project%20%3D%20%22Animal%20Sciences%22%20and%20status%20in%20(Done)%20and%20labels%20!%3D%20%22Risk%22");
$driver->pause(5000);
my $element = $driver->find_element('//*[@class=\'results-count-total results-count-link\']');
say $element->get_text();

