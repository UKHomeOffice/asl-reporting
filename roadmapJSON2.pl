#! /usr/local/bin/perl
use strict;
use warnings;
use 5.010;
use Cwd;
use lib cwd;
use JSON::Parse 'json_file_to_perl';
use Data::Dumper;
my $file = shift || die "No filename";

my $p = json_file_to_perl ($file);
my $DEBUG = 0;
my $progress = 0;
my $total = 0;
my $NEXT = 'Next';
my $SHORT_TERM = 'Short';
my $MEDIUM_TERM = 'Medium';
my $LONG_TERM = 'Long';
my %cards_hash;
my %lists_hash;
my @cards = @{$p->{cards}};
foreach my $card (@cards)
{
        $cards_hash{$card->{name}} = $card->{idList};
}

my @lists = @{$p->{lists}};
foreach my $list (@lists)
{
	if (!$list->{closed})
	{	
		$lists_hash{$list->{id}} = $list->{name};
	}
}

foreach my $cardName (keys %cards_hash)
{
	my $colText = $lists_hash{$cards_hash{$cardName}};
	if( $colText && $colText =~ /($NEXT|$SHORT_TERM|$MEDIUM_TERM|$LONG_TERM)/gi)
	{
		## say $cardName;
		 if($cardName =~ /\[\s*?(\d+)\s*?Points\s*?\]/i)
		 {
                 	my $points = $1;
                        $total += $points;
			## say "$cardName is $points points - total is $total ";

          	       if ($cardName =~ /\[\s*?(\d+)\s*?\%\s*?\]/)
                	 {
				## say $cardName;
                 		my $percentage = $1;
                 		## say "Percentage is $percentage";
                 		$progress += $points * ($percentage/100);
				## say "Progress is $progress";
                 	}
		 }
		
	}
}
my $date = `date +%Y%m%d`;
$date =~s/\n+//;
## say "Total is $total";
## say "Progress is $progress";
print "$date $progress $total";
