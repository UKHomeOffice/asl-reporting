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

my $driver;
$driver = Selenium::Firefox->new;
savefile($driver, $TRELLO_BASE, $TRELLO_ROADMAP_JSON, $TRELLO_USERNAME, $TRELLO_PASSWORD, $TRELLO_LOGIN_XPATH, $TRELLO_PASSWORD_XPATH, $TRELLO_ROADMAP_JSON_FILE);
exit(1);

