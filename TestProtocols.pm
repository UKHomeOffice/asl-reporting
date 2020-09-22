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
use TestBits;

our @ISA    = qw(Exporter);
our @EXPORT = qw(addProtocol customAddProtocol1 customAddProtocol2);


sub customAddProtocol1
{
	my $driver = shift;
        my $textfile = shift;
	clickOnThing($driver, 'a', 'tag_name', 'Protocols');
        selectThing($driver, '(//input[@type=\'text\'])', 'protocol.*title');
        replaceTextInThing($driver, 'Breeding of genetically-altered animals');
        
        clickOnThing($driver, 'button', 'tag_name', 'Continue');
        
        clickOnThing($driver,
        '//label[contains(.,\'Briefly describe the purposes of this protocol\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, 'To produce and provide genetically altered animals.');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*severity-mild');
        clickOnThing($driver,
        '//label[contains(.,\'Why are you proposing this severity category\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, 'The mice being bred will not be used for regulated procedures in this protocol. Phenotyping procedures will take in protocol 2. Quantification of scoliosis will be post-morten after schedule 1 killing. Similarly, samples for IHC and western blotting will be post-mortem.');
        
        ## click on the objective
        selectThing($driver,"//label[contains(.,\'Determine whether attenuation of the DNA damage response in mouse models of neurodegeneration is neuroprotective\')]");
        clickOnThing($driver,
        '//label[contains(.,\'What outputs are expected to arise from this protocol\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, 'Production of genetically-altered animals for protocol 2
Quantification of scoliosis
Analysis of the cell biology underpinning the neuroprotective effect.');
        
        clickOnThing($driver, 'h3', 'tag_name', 'Animals used in this protocol');
        
        ### Animals used in this protocol
        selectThing($driver,'//label[contains(.,\'Mice\')]');
        selectThing($driver,'//label[contains(.,\'Ferrets\')]');
	selectThing($driver,'(//label[contains(.,\'Adult\')])[1]');
	selectThing($driver,'(//label[contains(.,\'Adult\')])[2]');
        ### This does *all* of the boxes that match
	selectThing($driver, '(//input[@type=\'radio\'])', '.*continued-use-true', 1);
        clickOnThing($driver,
        '//label[contains(.,\'How did these animals start their use?\')]/following::div[1]',
	,'xpath');
        replaceTextInThing($driver, 'PPL 12345');
	selectThing($driver, '(//input[@type=\'radio\'])', '.*reuse-true', 1);
        clickOnThing($driver,
        '//label[contains(.,\'What is the maximum number of animals that will be used on this protocol\')]'
        ,'xpath');
        replaceTextInThing($driver, int(rand(100))+250);
	 selectThing($driver, '(//input[@type=\'radio\'])', '.*continued-use-true', 1);
       	clickOnThing($driver,
        '//label[contains(.,\'What is the maximum number of uses of this protocol per animal\')]'
        ,'xpath');
        replaceTextInThing($driver, int(rand(100))+250); 
        ## Genetically Altered Animals
        clickOnThing($driver, 'h3', 'tag_name', 'GAA');
        
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*gaas-true');
        clickOnThing($driver,
        '//label[contains(.,\'Which general types or strains will you be using and why?\')]/following::div[1]'
        ,'xpath');
	replaceTextInThing($driver, 'GA Strains from inbred strains such as C57BL6 Mice');
	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*gaas-harmful-false');

        
        clickOnThing($driver, 'h3', 'tag_name', 'Steps');
        
        clickOnThing($driver,
        '//label[contains(.,\'Describe the procedures that will be carried out during this step\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, 'Breeding and maintenance of genetically altered mice by conventional breeding methods.');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*optional.*false');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*adverse.*false');
        clickOnThing($driver, 'button', 'tag_name', 'Save step');
	clickOnThing($driver, 'button', 'tag_name', 'Add another step');
	my @divs = $driver->find_elements('//label[contains(.,\'Describe the procedures that will be carried out during this step\')]/following::div[1]');
	$divs[0]->click();
	replaceTextInThing($driver, 'Tissue biopsy to determine genetic status by one of the following methods: ear punch, blood sampling, hair sampling (AA).  If removal of tip of tail (AB) is scientifically necessary no more than 0.3 cm will be removed.  Rarely, due to technical problems during analysis, a second sample may be taken using the least invasive method.');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*optional.*true');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*adverse.*false');
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*code.*ab');

	clickOnThing($driver, 'button', 'tag_name', 'Save step');
        clickOnThing($driver, 'button', 'tag_name', 'Add another step');
@divs = $driver->find_elements('//label[contains(.,\'Describe the procedures that will be carried out during this step\')]/following::div[1]');
        $divs[0]->click();
        replaceTextInThing($driver, 'Maintenance of animals by methods appropriate to their genetic alteration until they reach a maximum of 12 months of age.');
	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*optional.*true');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*adverse.*false');
 	clickOnThing($driver, 'button', 'tag_name', 'Save step');
        clickOnThing($driver, 'button', 'tag_name', 'Add another step');
	@divs = $driver->find_elements('//label[contains(.,\'Describe the procedures that will be carried out during this step\')]/following::div[1]');
        $divs[0]->click();
        replaceTextInThing($driver, 'Animals not used on other protocols will be killed by:  a Schedule 1 method; or by exsanguination under terminal anaesthesia, completed by a Schedule 1 method; or by perfusion fixation under terminal anaesthesia.');
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol..*code.*ac');
	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*optional.*false');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*adverse.*false');
        clickOnThing($driver, 'button', 'tag_name', 'Save step');

	clickOnThing($driver, 'h3', 'tag_name', 'Animal experience');
        
        clickOnThing($driver,
        '//label[contains(.,\'Summarise the typical experience or end\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, 'No text provided');
        
clickOnThing($driver, 
        '//label[contains(.,\'Describe the general humane endpoints that you will apply during the protocol\')]/following::div[1]'
        ,'xpath');
        
        replaceTextInThing($driver, 'No text provided');
        
        clickOnThing($driver, 'h3', 'tag_name', 'Experimental design');
	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*quantitative-data-true');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*quantitative-data-guideline-true');
        clickOnThing($driver,
        '//label[contains(.,\'How will you ensure that you are using the most refined methodology\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, 'No text provided');
        
        clickOnThing($driver, 'h3', 'tag_name', 'Protocol justification');
      	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*justification-substances-true'); 
        my @questions = ('the most appropriate scientific approach',
        'the most refined for the purpose',
        'For each model and',
        'Why scientifically do the animals need to suffer to this degree',
        'achieve your scientific outputs with an earlier humane endpoint',
        'How will you assess the suitability of these substances',
        'How will you determine an appropriate dosing regimen');
        my @answers = (
	'The Tau35 mouse is a slowly progressing disease mode which may alleviate a key problems experienced over >20 years using aggressive mouse models of neurodegeneration: that compounds that are neuroprotective in the mice show no efficacy in human patients.

By using a genetic method of reducing Nbs1/Nbn levels, I avoid administering compounds (e.g. mirin an inhibitor of Mre11) to the mice for up to 12 months.',
	'There are no models of neurodegeneration in lower vertebrates (e.g. fish) that are suitable for these types of experiments.',
	'An animal model exhibiting neurodegenerative pathology is required for test whether the project strategy is effective in slowing or alleviating the pathology. The Nbs1_KO mouse is required to avoid long-term administration of pharmacological compounds.',
	'Neurodegeneration is progressive. It will not become clear that the strategy is effective at slowing or suppressing pathology until 12 months of age.',
	'At earlier ages the phenotypes of the Tau35 mice are insufficiently strong to be sure that the strategy is slowing or supressing disease progression.',
	'No text provided',
	'No text provided'
	);
	
	replaceTextInMultiple($driver, \@questions, '', \@answers);

	clickOnThing($driver, 'h3', 'tag_name', 'Fate of animals');
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*fate-killed');
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*killing-method-schedule-1');

        selectThing($driver, '//*[@id="complete-true"]');
        
        clickOnThing($driver, 'button', 'tag_name', 'Continue');
	yesYesYes($driver, 1);        
	return 1;        	
}

sub customAddProtocol2
{
	my $driver = shift;
        my $textfile = shift;
	clickOnThing($driver, 'a', 'tag_name', 'Protocols');
	clickOnThing($driver, 'button', 'tag_name', 'Add another protocols');
        selectThing($driver, '(//input[@type=\'text\'])', 'protocol.*title');
	replaceTextInThing($driver, 'Testing of Tau35 pathology in Nbs1/Nbn heterozygous mice');
	##clickOnThing($driver, 'button', 'tag_name', 'Continue');
	clickOnThing($driver, '//button[text()=\'Continue\']','xpath','', 0);
	clickOnThing($driver,
        '//label[contains(.,\'Briefly describe the purposes of this protocol\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, 'To determine whether reducing Nbs1/Nbn levels slows or suppresses the neurodegenerative pathology of Tau35 mice.');
	$driver->pause(10000000000);
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*severity-moderate');
        clickOnThing($driver,
        '//label[contains(.,\'Why are you proposing this severity category\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        ## click on the objective
        selectThing($driver,"//label[contains(.,\'\')]");
        clickOnThing($driver,
        '//label[contains(.,\'What outputs are expected to arise from this protocol\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'h3', 'tag_name', 'Animals used in this protocol');
        
        ### Animals used in this protocol
        selectThing($driver,'//label[contains(.,\'Mice\')]');
        selectThing($driver,'//label[contains(.,\'Embryo\')]');
        selectThing($driver,'//label[contains(.,\'Neonate\')]');
        selectThing($driver,'//label[contains(.,\'Adult\')]');
        selectThing($driver,'//label[contains(.,\'Pregnant\')]');
        selectThing($driver,'//label[contains(.,\'Aged\')]');
        selectThing($driver,'//label[contains(.,\'Juvenile\')]');
        selectThing($driver, '//input[@value=\'true\']', 'protocol.*continued-use-true');
        clickOnThing($driver,
        '//label[contains(.,\'How did these animals start their use\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        selectThing($driver, '//input[@value=\'true\']','protocol.*reuse-true');
        clickOnThing($driver,
        '//label[contains(.,\'Describe any procedure that may have been applied to these animals\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver,
        '//label[contains(.,\'What is the maximum number of uses of this protocol on this type of animal\')]'
        ,'xpath');
        replaceTextInThing($driver, '1000');
        
        ## Genetically Altered Animals
        clickOnThing($driver, 'h3', 'tag_name', 'GAA');
        
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*gaas-true');
	clickOnThing($driver,
        '//label[contains(.,\'Which general types or strains will you be using and why\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        selectThing($driver, '//input[@value=\'true\']', 'protocol.*gaas.*harmful.*true');
        clickOnThing($driver,
        '//label[contains(.,\'Why are each of these harmful phenotypes necessary\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver,
        '//label[contains(.,\'How will you minimise the harms associated with these phenotypes\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'h3', 'tag_name', 'Steps');
        
        clickOnThing($driver,
        '//label[contains(.,\'Describe the procedures that will be carried out during this step\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        
        selectThing($driver, '//input[@value=\'false\']', 'protocol.*optional.*false');
        
        selectThing($driver, '//input[@value=\'true\']', 'protocol.*adverse.*true');
        clickOnThing($driver,
        '//label[contains(.,\'What are the likely adverse effects of this step\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        clickOnThing($driver,
        '//label[contains(.,\'How will you monitor for, control, and limit any of these adverse effects\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        clickOnThing($driver,
        '//label[contains(.,\'What are the humane endpoints for this step\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'button', 'tag_name', 'Save step');
        
        clickOnThing($driver, 'h3', 'tag_name', 'Animal experience');
        
        clickOnThing($driver,
        '//label[contains(.,\'Summarise the typical experience or end\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
clickOnThing($driver, 
        '//label[contains(.,\'Describe the general humane endpoints that you will apply during the protocol\')]/following::div[1]'
        ,'xpath');
        
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'h3', 'tag_name', 'Experimental design');
	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*quantitative-data-true');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*quantitative-data-guideline-true');
        clickOnThing($driver,
        '//label[contains(.,\'How will you ensure that you are using the most refined methodology\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'h3', 'tag_name', 'Protocol justification');
       
	clickOnThing($driver,
        '//label[contains(.,\'the most appropriate scientific approach\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
 
        clickOnThing($driver,
        '//label[contains(.,\'the most refined for the purpose\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));

        clickOnThing($driver,
        '//label[contains(.,\'For each model and\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));

        clickOnThing($driver,
        '//label[contains(.,\'Why scientifically do the animals need to suffer to this degree\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver,
        '//label[contains(.,\'achieve your scientific outputs with an earlier humane endpoint\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
       	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*justification-substances-true');
        clickOnThing($driver,
        '//label[contains(.,\'How will you assess the suitability of these substances\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver,
        '//label[contains(.,\'How will you determine an appropriate dosing regimen\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        clickOnThing($driver, 'h3', 'tag_name', 'Fate of animals');
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*fate-killed');
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*killing-method-schedule-1');

        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*killing-method-other');



        clickOnThing($driver,
        '//label[contains(.,\'For each non-schedule 1 method, explain why this is necessary\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*fate-kept-alive');
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*fate-continued-use');
        
        clickOnThing($driver,
        '//label[contains(.,\'Please state the relevant protocol\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        selectThing($driver, '//*[@id="complete-true"]');
        
        clickOnThing($driver, 'button', 'tag_name', 'Continue');
	yesYesYes($driver, 1);        
	return 1;        	
}
sub addProtocol
{
	my $driver = shift;
        my $textfile = shift;
        my $objective = shift;
	my $number = shift // 1;
	if ($number >1 )
	{
		clickOnThing($driver, 'button', 'tag_name', 'Add another protocol');
	}
        clickOnThing($driver, 
		'(//input[contains(@id,"protocols") and contains(@id, "title")])[1]', 'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'button', 'tag_name', 'Continue');
        clickOnThing($driver,
        '//label[contains(.,\'Briefly describe the purposes of this protocol\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
	if ($number > 1) { $driver->pause(100000000); }
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*severity-severe');
        clickOnThing($driver,
        '//label[contains(.,\'Why are you proposing this severity category\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        ## click on the objective
        selectThing($driver,"//label[contains(.,\'$objective\')]");
	##clickOnThing($driver,
	##'//label[contains(.,\'What outputs are expected to arise from this protocol\')]/following::div[1]'
	##,'xpath');
	##replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'h3', 'tag_name', 'Animals used in this protocol');
        
        ### Animals used in this protocol
        selectThing($driver,'//label[contains(.,\'Mice\')]');
        selectThing($driver,'//label[contains(.,\'Embryo\')]');
        selectThing($driver,'//label[contains(.,\'Neonate\')]');
        selectThing($driver,'//label[contains(.,\'Adult\')]');
        selectThing($driver,'//label[contains(.,\'Pregnant\')]');
        selectThing($driver,'//label[contains(.,\'Aged\')]');
        selectThing($driver,'//label[contains(.,\'Juvenile\')]');
        selectThing($driver, '//input[@value=\'true\']', 'protocol.*continued-use-true');
        clickOnThing($driver,
        '//label[contains(.,\'How did these animals start their use\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        selectThing($driver, '//input[@value=\'true\']','protocol.*reuse-true');
        clickOnThing($driver,
        '//label[contains(.,\'Describe any procedure that may have been applied to these animals\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver,
        '//label[contains(.,\'What is the maximum number of animals that will be used on this protocol\')]'
        ,'xpath');
        replaceTextInThing($driver, int(rand(500))+200);
        
        ## Genetically Altered Animals
        clickOnThing($driver, 'h3', 'tag_name', 'GAA');
        
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*gaas-true');
	clickOnThing($driver,
        '//label[contains(.,\'Which general types or strains will you be using and why\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        selectThing($driver, '//input[@value=\'true\']', 'protocol.*gaas.*harmful.*true');
        clickOnThing($driver,
        '//label[contains(.,\'Why are each of these harmful phenotypes necessary\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver,
        '//label[contains(.,\'How will you minimise the harms associated with these phenotypes\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'h3', 'tag_name', 'Steps');
        
        clickOnThing($driver,
        '//label[contains(.,\'Describe the procedures that will be carried out during this step\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        
        selectThing($driver, '//input[@value=\'false\']', 'protocol.*optional.*false');
        
        selectThing($driver, '//input[@value=\'true\']', 'protocol.*adverse.*true');
        clickOnThing($driver,
        '//label[contains(.,\'What are the likely adverse effects of this step\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        clickOnThing($driver,
        '//label[contains(.,\'How will you monitor for, control, and limit any of these adverse effects\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        clickOnThing($driver,
        '//label[contains(.,\'What are the humane endpoints for this step\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'button', 'tag_name', 'Save step');
        
        clickOnThing($driver, 'h3', 'tag_name', 'Animal experience');
        
        clickOnThing($driver,
        '//label[contains(.,\'Summarise the typical experience or end\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
clickOnThing($driver, 
        '//label[contains(.,\'Describe the general humane endpoints that you will apply during the protocol\')]/following::div[1]'
        ,'xpath');
        
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'h3', 'tag_name', 'Experimental design');
	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*quantitative-data-true');
        selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*quantitative-data-guideline-true');
        clickOnThing($driver,
        '//label[contains(.,\'How will you ensure that you are using the most refined methodology\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver, 'h3', 'tag_name', 'Protocol justification');
       
	clickOnThing($driver,
        '//label[contains(.,\'the most appropriate scientific approach\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
 
        clickOnThing($driver,
        '//label[contains(.,\'the most refined for the purpose\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));

        clickOnThing($driver,
        '//label[contains(.,\'For each model and\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));

        clickOnThing($driver,
        '//label[contains(.,\'Why scientifically do the animals need to suffer to this degree\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver,
        '//label[contains(.,\'achieve your scientific outputs with an earlier humane endpoint\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
       	selectThing($driver, '(//input[@type=\'radio\'])', 'protocol.*justification-substances-true');
        clickOnThing($driver,
        '//label[contains(.,\'How will you assess the suitability of these substances\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        clickOnThing($driver,
        '//label[contains(.,\'How will you determine an appropriate dosing regimen\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        clickOnThing($driver, 'h3', 'tag_name', 'Fate of animals');
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*fate-killed');
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*killing-method-schedule-1');

        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*killing-method-other');



        clickOnThing($driver,
        '//label[contains(.,\'For each non-schedule 1 method, explain why this is necessary\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*fate-kept-alive');
        
        selectThing($driver, '(//input[@type=\'checkbox\'])', 'protocol.*fate-continued-use');
        
        clickOnThing($driver,
        '//label[contains(.,\'Please state the relevant protocol\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
	## selectThing($driver, '//*[@id="complete-true"]');
        
	## clickOnThing($driver, 'button', 'tag_name', 'Continue');
	yesYesYes($driver, 1);        
	return 1;        	
}
return 1;

