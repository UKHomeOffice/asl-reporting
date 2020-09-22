#! /usr/bin/perl 
use strict;
use warnings;
use Cwd;
use lib cwd;
use Selenium::Remote::Driver;
use Selenium::Chrome;
use Selenium::Firefox;
use Selenium::Remote::WDKeys;
use File::Slurp;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "cp";
use TestASL;
use TestBits;
use TestReader;

print "usage is: <file>";
my $file     = shift || die "No file";
my $driver = Selenium::Firefox->new;
readScript($driver, $file);
