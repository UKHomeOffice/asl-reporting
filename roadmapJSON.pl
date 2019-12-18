use strict;
use warnings;
use Cwd;
use lib cwd;
use File::Slurp;
use 5.010;
use Path::Tiny qw(path);
use JSON::Parse 'json_file_to_perl';

my $DEBUG = 0;
my $total = 0;
my $SMALL_RISKS = 'SMALL RISKS < 200';
my $MED_RISKS = 'MED RISKS exp 200-999';
my $BIG_RISKS= 'BIG RISKS > exp 1000';


my $JSON_FILE = 'https://trello.com/b/KpVVpCty.json';


my $file = shift;
-e $file || die "json file doesn't exist";
my $p = json_file_to_perl ($file);

my %cards_hash;
my %lists_hash;
my @cards = @{$p->{cards}};
foreach my $card (@cards)
{
        if (!$card->{closed})
        {
		$cards_hash{$card->{name}} = $card->{idList};
	}
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

	if (($colText) 
	&&(($colText =~ /$BIG_RISKS/) || ($colText =~ /$MED_RISKS/) || ($colText =~ /$SMALL_RISKS/)))
	{
		$cardName =~ /\[\s*exp\s*(\d+)]/i || say "No points on card $cardName";
		my $points = $1;
		if($points)
		{
			$total += $points;
			say "$cardName is $points points - total is $total ";
		}
	}
}
my $date = `date +%Y%m%d`;
$date =~s/\n+//;
say "Total is $total";
say "$date $total";
