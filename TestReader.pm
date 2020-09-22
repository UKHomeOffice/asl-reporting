use Selenium::Remote::Driver;
use Selenium::Chrome;
use Selenium::Remote::WDKeys;
use File::Slurp;
use strict;
use 5.010;
use Path::Tiny qw(path);
use File::Copy "cp";
use Test::Assert ':all';
use Exporter;
use TestASL;
use TestProtocols;


our @ISA    = qw(Exporter);
our @EXPORT = qw(readScript);
sub readScript
{
my $driver = shift;
my $filename = shift;
my $textfile = shift // 'text.txt';

open(my $fh, '<', $filename);

while(<$fh>)
{
	my @bits = split /\s\s\s\s+/;
	my $value = "";
	say $bits[0];
    if($bits[0]=~ /^#.*/)
    {
		goto END;
	}
	if($bits[1] =~ /go/)
	{
            $driver->get($bits[0]);
	    goto END;
	}
	if($bits[1] =~ /click/)
	{
		clickOnThing($driver, $bits[0], 'xpath');
		if($bits[2] && $bits[2] =~ /\d+/)
		{
			$driver->pause($bits[2]);
		}
		goto END;
	}
	if ($bits[1] =~ /number/)
	{
	    $value = $bits[2] + int(rand($bits[3] - $bits[2]));	
    }
	if($bits[1] =~ /text/)
	{
		if ($bits[2])
		{
			if($bits[2] =~ /var/)
			{
				$value = eval($bits[3]);
			}
			else
			{
				$value = $bits[2];
			}
		}
		else
		{
			$value = someText(10, $textfile);
		}
	}
	if($bits[1] =~ /select/)
	{
		if($bits[2] =~ /replace/)
                {
                        my $replace_value = eval($bits[3]);
			say $replace_value;
			
                        $bits[0] =~ s/XXX_REPLACE_XXX/$replace_value/;
			say $bits[0];
                }

		selectThing($driver, $bits[0]);

		if($bits[2] && $bits[2] =~ /\d+/)
        	{
            		$driver->pause($bits[2]);
        	}
		goto END;
	}
	if($bits[1] =~ /screen/)
	{
		$driver->capture_screenshot($bits[0], {'full' => 1});
		goto END;
	}
	clickOnThing($driver, $bits[0], 'xpath');
        replaceTextInThing($driver, $value);
	END:
}
}

1;
