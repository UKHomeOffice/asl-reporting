#! /usr/local/bin/perl
use strict;
use warnings;
use 5.010;
use Cwd;
use lib cwd;
use JSON::Parse 'json_file_to_perl';
use Data::Dumper;
use Tally;
my $file = shift || die "No filename";

my $p = json_file_to_perl ($file);
my $DEBUG = 0;
my $progress = 0;
my $total = 0;
my $NEXT = 'Next';
my $SHORT_TERM = 'Short';
my $MEDIUM_TERM = 'Medium';
my $LONG_TERM = 'Long';
my $DONE = 'Done';
my %cards_hash;
my %lists_hash;
my @cards = @{$p->{cards}};
my $publishing = new Tally("Publishing", 0,0,0,0);
my $enhancement = new Tally("Enhancements", 0,0,0,0);
my $history = new Tally("History", 0,0,0,0);
my $compliance=new Tally("Compliance", 0,0,0,0);
my $report= new Tally("Reports", 0,0,0,0);
my $referrals= new Tally("Referrals", 0,0,0,0);


my @lists = @{$p->{lists}};
foreach my $list (@lists)
{
        if (!$list->{closed})
        {
                $lists_hash{$list->{id}} = $list->{name};
		say "List name is: $list->{name}";
        }
}

foreach my $card (@cards)
{
	my $points = 0;
	my $percentage = 0;
	my $cardName = $card->{name};
	my $idList = $card->{idList};
        if (!exists $lists_hash{$idList})
	{
		goto NEXT;
	}
	say "List is: $lists_hash{$idList}";
	if($cardName =~  /\[\s*?Not\s*?Done\s*?\]/i)
	{
		say "Ignoring $cardName";
		goto NEXT;
	}
       
	if($cardName =~ /\[\s*?(\d+)\s*?Points\s*?\]/i)
        {
        	$points = $1;
                say "Points are $points";
                if ($cardName =~ /\[\s*?(\d+)\s*?\%\s*?\]/)
                {
                	$percentage = $1;
                        say "Percentage is $percentage";
                }
        }
	elsif($lists_hash{$idList} =~ /Done/)
	{
		$points = 144;
		$percentage = 100;
	}


	my @label_list = @{$card->{labels}};
	my $category = $label_list[0]->{name} || goto NEXT;
	## sort the cards into buckets
	if($category =~ /publishing/i)
	{
		$publishing->doTally($points, $percentage);
	}
	elsif($category=~ /enhancement/i)
	{
		$enhancement->doTally($points, $percentage);
	}
	elsif($category=~ /history/i)
	{
		$history->doTally($points, $percentage);
	}
	elsif($category=~ /compliance/i)
	{
		$compliance->doTally($points, $percentage);
	}
	elsif($category=~ /report/i)
	{
		$report->doTally($points, $percentage);
	}
	elsif($category=~ /referrals/i)
	{
		$referrals->doTally($points, $percentage);
	}
	else
	{
		goto NEXT;
	}
	say($cardName);
	
	NEXT:
}

say($publishing->getTally());
say($enhancement->getTally());
say($history->getTally());
say($compliance->getTally());
say($report->getTally());
say($referrals->getTally());


exit(0);

foreach my $cardName (keys %cards_hash)
{
	my $colText = $lists_hash{$cards_hash{$cardName}};
	if( $colText && $colText =~ /($NEXT|$SHORT_TERM|$MEDIUM_TERM|$LONG_TERM)/gi)
	{
	         say $cardName;

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
	elsif ( $colText && $colText =~ /($DONE)/gi)
	{
		 say $cardName;
		 if($cardName =~ /\[\s*?(\d+)\s*?Points\s*?\]/i)
                 {
                        my $points = $1;
                        $total += $points;
                        $progress += $points;
			say $points;
                 }
	}
}
my $date = `date +%Y%m%d`;
$date =~s/\n+//;
## say "Total is $total";
## say "Progress is $progress";
print "$date $progress $total";
