#!/usr/bin/perl

use strict;
use warnings;

use HTML::TableExtract;
use LWP::Simple;
use Data::Dumper;

my $file = 'Table3.htm';
unless ( -e $file ) {
    my $rc = getstore(
        'https://en.wikipedia.org/wiki/List_of_London_Underground_stations',
        $file);
    die "Failed to download document\n" unless $rc == 200;
}

my @headers = ('Station');

my $te = HTML::TableExtract->new(
    headers => \@headers
);

$te->parse_file($file);

my ($table) = $te->tables;
my @list = @{$table->{grid}};

foreach my $list_item(@list)
{
	my $station = ${${$list_item}[0]};
	my $area = ${${$list_item}[3]};
	my $zone = ${${$list_item}[4]};
	$station =~ s/(\n|\r)+//g;
	print $station."    ".$area."    ".$zone."\n";
}


