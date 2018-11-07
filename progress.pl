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
my $total = 0;

my $file = shift;
-e $file || die "html file doesn't exist";

my $root = HTML::TreeBuilder->new_from_file($file);

my @counts =  $root->look_down('class' =>'results-count-total results-count-link');
my $count = "";
foreach (@counts)
{
	$count = $_->as_text;
}

say $count;

