#! /usr/local/bin/perl
use strict;
use warnings;
use Cwd;
use lib cwd;
## use ReportConsts;
use Data::Dumper;
use ReportConsts;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "copy";

our @ISA    = qw(Exporter);
our @EXPORT = qw(sprint onlyWednesdays);

sub sprint
{
	my $offset = shift // 'today';
    (my $start_seconds = `date --date "20200527" +%s`) =~ s/\n//g;
	(my $date_long = `date --date \'$offset\' "+%A %d %B %Y"`) =~ s/\n//g;
    (my $end_seconds = `date --date \"$date_long\" +%s`) =~ s/\n//g;
	my $sprint =  int((int($end_seconds) - int($start_seconds))/(60*60*24*14))+59;
    return $sprint;
}

sub onlyWednesdays
{
	my $filename = shift || "No filename";

	open(my $fh, '<', $filename);
	while(<$fh>)
	{
    	my $line= $_;
    	if($line=~ /^(\d+)/)
    	{
        	my $day = `date -d "$1" +%A`;
        	if ($day =~ /Wednesday/)
        	{
            	print $line;
        	}
    	}
		else
		{
				print $line;
		}
	}

}

1;
