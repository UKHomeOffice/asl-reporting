#! /usr/local/bin/perl
use strict;
use warnings;
use 5.010;
use Cwd;
use lib cwd;
use JSON::Parse 'json_file_to_perl';
use Data::Dumper;
my $p = json_file_to_perl ('EmrhbGKu.json');
my %cards_hash;
my %lists_hash;
my @cards = @{$p->{cards}};
foreach my $card (@cards)
{
	say $card->{name};
	say $card->{idList};
        $cards_hash{$card->{name}} = $card->{idList};
}

my @lists = @{$p->{lists}};
foreach my $list (@lists)
{
        say $list->{name};
        say $list->{id};
	$lists_hash{$list->{id}} = $list->{name};
}

foreach my $card (keys %cards_hash)
{
	my $title = $card;
        say $card;
	my $column = $lists_hash{$cards_hash{$card}};
        say $column;
        if ($column =~ /Not Started/)
	{
	}
	if ($column =~ /Done/)
	{
	}
	if ($column =~ /In Progress/)
	{
	}
}

