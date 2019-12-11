#! /usr/local/bin/perl
use strict;
use warnings;
use Cwd;
use lib cwd;
use ReportConsts;
use Selenium::Remote::Driver;
use Selenium::Chrome;
use Selenium::Firefox;
use Firefox::Marionette();
use Selenium::Remote::WDKeys;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "copy";
use TestASL;
use TestBits;


my $driver = Selenium::Firefox->new ();
$driver->get('https://www.theguardian.com/uk');
my $filename = "test.png";
$driver->capture_screenshot($filename, {'full' => 1});
