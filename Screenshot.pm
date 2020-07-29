#! /usr/local/bin/perl
use strict;
use warnings;
use Cwd;
use lib cwd;
## use ReportConsts;
use Selenium::Remote::Driver;
use Selenium::Chrome;
use Selenium::Firefox;
##use Firefox::Marionette();
use Selenium::Remote::WDKeys;
use Data::Dumper;
use ReportConsts;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "copy";
use TestASL;
use TestBits;

our @ISA    = qw(Exporter);
our @EXPORT = qw(screenshot savefile);


sub screenshot
{
	##say Dumper(@_);
	my $driver = shift || die "No driver";
	my $first_url = shift || die "No first url";
	my $second_url = shift || die "No second url";
	my $username = shift || die "No username";
	my $password = shift || die "No password";
	my $username_box = shift // '//*[@id="login-form-username"]';
        my $password_box = shift // '//*[@id="login-form-password"]';



	$driver->fullscreen_window();
	$driver->get($first_url);
	$driver->pause(5000);
	login($driver, $username, $password, $username_box, $password_box);
	$driver->pause(5000);
	$driver->get($second_url);
	$driver->pause(5000);
	my $filename = $OUTPUT_FILE;
	$driver->capture_screenshot($filename, {'full' => 1});
	$driver->pause(5000);
}

sub savefile
{
	##say Dumper(@_);
        my $driver = shift || die "No driver";
        my $first_url = shift || die "No first url";
        my $second_url = shift || die "No second url";
        my $username = shift || die "No username";
        my $password = shift || die "No password";
        my $username_box = shift;
        my $password_box = shift;
	my $file = shift;

        $driver->fullscreen_window();
        $driver->get($first_url);
        $driver->pause(5000);
        login($driver, $username, $password, $username_box, $password_box);
        $driver->pause(5000);
##        $driver->get($second_url);
	print Dumper($driver->get_all_cookies());
	$driver->pause(10000000);


}
1;
