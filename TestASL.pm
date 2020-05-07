package TestASL;
use strict;
use warnings;
use Cwd;
use lib cwd;
use Try::Tiny;
use Selenium::Remote::Driver;
use Selenium::Chrome;
use Selenium::Remote::WDKeys;
use File::Slurp;

use 5.010;
use Path::Tiny qw(path);
use File::Copy "cp";

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT =
  qw(yesOrNo deSelectThing startBrowser success isOnPage replaceTextInMultiple clickOnThing replaceTextInThing someText selectThing $FAIL_WAIT);
our ($FAIL_WAIT);

my $file_content;
my $word_count;

sub startBrowser {
    my $headless = shift // "";
    my $driver;
    if ( !$headless ) {

        $driver = Selenium::Chrome->new(
            'browser_name'       => 'chrome',
            'extra_capabilities' => {
                'chromeOptions' => {
                    'prefs' => {
                        'download.default_directory' =>
                          '/home/mark/projects/asltesting/Downloads'
                    }
                }
            }
        );
    }
    else {
        $driver = Selenium::Chrome->new(
            browser_name       => 'chrome',
            extra_capabilities => {
                chromeOptions =>
                  { args => [ 'window-size=1920,1080', 'headless', ] }
            },
        );
    }
    return $driver;
}

sub selectThing {
    my $page       = shift;
    my $query      = shift;
    my $regexp     = shift // 0;
    my $everything = shift // 0;
    my $clicked    = 0;
    my @elements   = $page->find_elements($query);

    say STDERR "Trying to click on $query $regexp";
    foreach my $element (@elements) {
        my $id_text = $element->get_attribute('id');
        if ( ( $id_text =~ /$regexp/i ) || !$regexp ) {
            if ( !$element->get_attribute('checked') ) {
                $element->click();
                $clicked = 1;
                $page->pause(1000);
            }
            if ( !$everything ) {
                return 1;
            }
        }
    }
    if ($clicked) { return 1; }
    ##//die "Didn't find anything to click.";
    say "Something went wrong Didn\'t find anything to click.";
	say STDERR "FAIL WAIT is".$FAIL_WAIT;
    if($FAIL_WAIT =~ /die/)
    {
        die;
    }
    if($FAIL_WAIT =~ /wait/)
    {
            $page->pause(1000000);
    }
    return 0;
}

sub deSelectThing {
    my $page   = shift;
    my $query  = shift;
    my $regexp = shift;
    if ( !$regexp ) { $regexp = 0; }
    my @elements = $page->find_elements($query);

    say STDERR "Trying to click on $query $regexp";
    foreach my $element (@elements) {
        my $id_text = $element->get_attribute('id');
        if ( ( $id_text =~ /$regexp/i ) || !$regexp ) {
            if ( $element->get_attribute('checked') ) {
                $element->click();
                $page->pause(1000);
            }
            return 1;
        }
    }
    ##//die "Didn't find anything to click.";
    say STDERR "Something went wrong Didn\'t find anything to click.";
    say STDERR "FAIL WAIT is".$FAIL_WAIT;
    if($FAIL_WAIT =~ /die/)
    {
	die;
    }
    if($FAIL_WAIT =~ /wait/)
    {
	    $page->pause(1000000);
    }
    return 0;
}

sub isOnPage {
    my $driver   = shift;
    my $text     = shift;
    my @elements = $driver->find_elements("//*[contains(.,\'$text\')]");
    if ( $#elements > 0 ) {
        return 1;
    }
    return 0;
}

sub success {
    my $driver = shift;
    my $text   = shift;
    if ( isOnPage( $driver, $text ) ) {
        say STDERR "Success! Found $text ", exit 0;
    }
}

sub clickOnThing {
    my $page   = shift;
    my $query  = shift;
    my $scheme = shift;
    my $text   = shift // "";
    my $nth    = shift // 0;
    if ($query =~ /following/)
    {
	$query =~ /\'(.*)\'/;
	say STDERR "ANSWERING: ".$1;
    }
    else
    {
    	say STDERR "Query: $query, Scheme: $scheme, Text: $text Nth: $nth";
    }

    my @elements = $page->find_elements( $query, $scheme );
    my $count = 0;
    foreach my $element (@elements) {
        if (   ( ( $nth != 0 ) && ( $nth == $count ) )
            || ( !$nth ) )
        {
            if ($text) {
                if ( $element->get_text() =~ /$text/i ) {
                    $element->click();
                    return 1;
                }
            }
            else {
                $element->click();
                return 1;
            }
        }
        $count++;
    }

    say STDERR "Couldn't find Query: $query, Scheme: $scheme, Text: $text";
    say STDERR $FAIL_WAIT;
    if($FAIL_WAIT =~ /die/)
    {
        die;
    }
    if($FAIL_WAIT =~ /wait/)
    {
            $page->pause(1000000);
    }
    return 0;
}

sub replaceTextInMultiple {
    my $driver        = shift;
    my $questions_ref = shift;
    my @questions     = @{$questions_ref};
    my @answers;
    my $textfile    = shift;
    my $answers_ref = shift // 0;
    my $count       = 0;
    if ($answers_ref) {
        @answers = @{$answers_ref};
    }
    foreach my $question (@questions) {

        my @elements; 
	if ($question =~ /\'/)
	{
		my @bits = split ($question, /\'/);
		my $query= '//label[';
		
		foreach my $bit (@bits)
		{
			$query .= "contains(\'$bit\') and";
		}
		$query = substr($query, 0, -3);	
		$query .= ']';	
		@elements = $driver->
                        find_elements($query);
	}
	else
	{
		@elements = $driver->
			find_elements( '//label[contains(.,\'' . $question . '\')]/following::div[1]');
	}	


	foreach my $element( @elements)
	{
		say STDERR "ANSWERING:".$question;
        	if(eval{$element->click()})
		{
		}
		else
		{
			say STDERR $FAIL_WAIT;
    			if($FAIL_WAIT =~ /die/)
    			{
        			die;
    			}
    			if($FAIL_WAIT =~ /wait/)
    			{
            			$driver->pause(1000000);
    			}
    			return 0;
		}
		if ($answers_ref) {
            	replaceTextInThing( $driver, $answers[$count] );
        	}
        	else {
            	replaceTextInThing( $driver, someText( 10, $textfile ) );
        	}
        	$count++;
	}
    }

}

sub replaceTextInThing {
    my $page = shift;
    my $text = shift;
    utf8::decode($text);

    my $loc_element = $page->get_active_element();
    $loc_element->send_keys( KEYS->{'control'}, 'a' );
    $page->send_keys_to_active_element($text);
}

sub someText {
    my $number = shift;
    my $file   = shift;
    ## read in the whole file as a string
    if ( !$file_content ) {
        $file_content = read_file($file);
        $file_content =~ s/[[:punct:]]/ /g;
        $file_content =~ s/\s+/ /g;
        $file_content = lc $file_content;
        $word_count = 1 + ( $file_content =~ tr{ }{ } );
    }
    my $start = int( rand( $word_count - $number ) ) + $number;
    $number += $start;
    my $returnString = join ' ',
      ( split /\s+/, $file_content )[ $start .. $number ];
    say STDERR "TESTTEXT:".$returnString;
    return $returnString;
}

sub yesOrNo
{
        return 1 + int(rand (2)) - 1;
}


1;
