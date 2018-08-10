use strict;
use warnings;
use Cwd;
use lib cwd;
use File::Slurp;
use 5.010;
use Path::Tiny qw(path);
use HTML::TreeBuilder;
use HTML::Element;

my $DEBUG = 0;
my $progress = 0;
my $total = 0;
my $INPROGRESS = 'In Progress';
my $DONE = 'Done';
my $NOTSTARTED = 'Not Started';

my $file = shift;
-e $file || die "html file doesn't exist";

my $root = HTML::TreeBuilder->new_from_file($file);

##my @statuses =  $root->look_down('class' => 'list-header-name mod-list-name js-list-name-input' );
my @statuses =  $root->look_down('class' =>'js-list list-wrapper');
my @cardLists = $root->look_down('class' => 'list-cards u-fancy-scrollbar u-clearfix js-list-cards js-sortable ui-sortable');

## find the headings for the columns
foreach (@statuses)
{
	my $columnName = $_->look_down('class' => 'list-header-name mod-list-name js-list-name-input');
	my $colText = $columnName->as_text;
	say "COLUMN NAME is ".$colText if $DEBUG ;


	my @cards = $_->look_down ('class' => 'list-card-title js-card-name');
	foreach (@cards)
	{
		my $cardName =  $_->as_text;
		##say $cardName;
		if (($colText =~ /$NOTSTARTED/) || ($colText =~ /$INPROGRESS/) || ($colText =~ /$DONE/))
		{
			$cardName =~ /\[\s*?(\d+)\s*?Points\s*?\]/;
			my $points = $1;
			$total += $points;
			print "$cardName is $points points - total is $total ";
                         
			if (($colText =~ /$INPROGRESS/) && 			
				($cardName =~ /\[\s*?(\d+)\s*?\%\s*?\]/))
			{
				my $percentage = $1;
				print "percentage is $percentage";
				$progress += $points * ($percentage/100);
				 print "Progress is $progress";
			}
			if ($colText =~ /$DONE/)
			{
				$progress += $points;
			}
			print "\n";
		}
	}
}
my $date = `date +%Y%m%d`;
$date =~s/\n+//;
say "Total is $total";
say "Progress is $progress";
print "$date $progress $total";

