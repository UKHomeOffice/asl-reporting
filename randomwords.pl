my $number = shift;

my $command = "shuf /usr/share/dict/words | tail -n $number";
my $result = `$command`;
$result =~s/(\n|\r)/ /g;
print $result;
