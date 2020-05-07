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


our @ISA    = qw(Exporter);
our @EXPORT = qw(dealWithExemptions fillInPPL login getToProjects createIfNotThere);
our $FAIL_WAIT;

my $file_content;
my $word_count;
my $objective1;
my $objective2;

sub dealWithExemptions
{
	my $driver = shift;
	my $textfile= shift;
	my $counter = 1;
	my $option;
        while( eval{$option = $driver->find_element('(//input[@type=\'checkbox\'])['.$counter.']')} || 0)
	{
		if(yesOrNo())
		{
			selectThing($driver, '(//input[@type=\'checkbox\'])['.$counter.']');
		}
		$counter++;
	}
        $counter = 1;
	while( eval{$option = $driver->find_element('(//textarea)['.$counter.']')} || 0)
        {
                if($option->is_displayed())
		{
			$option->click();
			replaceTextInThing($driver, someText(10, $textfile));
		}
		$counter++;
        }
	clickOnThing($driver, 'button', 'tag_name', 'Continue');
}


sub login
{
        my $driver = shift;
        my $username = shift;
        my $password = shift;
	my $userbox = shift // '//*[@id="login-form-username"]';
	my $passwordbox = shift // '//*[@id="login-form-password"]';
        clickOnThing($driver, $userbox, 'xpath');
        $driver->send_keys_to_active_element($username);
        clickOnThing($driver, $passwordbox, 'xpath');
        $driver->send_keys_to_active_element($password);
        clickOnThing($driver, '//input[@value=\'Log In\']', 'xpath');
}

sub yesYesYes
{
	my $driver = shift;
        my $nth = shift // 0;
	clickOnThing($driver, '//button[text()=\'Continue\']','xpath','', $nth);
        selectThing($driver, '//*[@id="complete-true"]');
        clickOnThing($driver, 'button', 'tag_name', 'Continue');
}

sub projectName
{
	my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
	my @days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	(my $sec,my $min, my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst) = localtime();
	my $returnString =  "TEST$days[$wday]$mday$months[$mon]";   
	say $returnString;
	return $returnString;
}

sub customIntroductoryDetails
{
	my $driver = shift;
        my $textfile = shift;
        my $nonce = shift // "";

        clickOnThing($driver,  '//*[@id="title"]', 'xpath');
        replaceTextInThing($driver,"$nonce Attenuating the DNA damage response as a neuroprotective strategy for neurodegeneration");
        clickOnThing($driver, '//label[contains(.,\'aim of this project\')]/following::div[1]', 'xpath');
        my $temp_string = "Neurodegeneration disorders are incurable diseases that affect the nervous system. There are many different forms, including dementias such as Alzheimer’s disease and disorders affecting movement, such as Parkinson’s disease. There is an urgent need to develop effective therapies that can slow the progression of the diseases.

This project is to test whether disease can be slowed by reducing the ability of nerve cells in the brain to recognise and act on damage to the DNA.";
        utf8::decode($temp_string);
	replaceTextInThing($driver, $temp_string);

        ##Why is it important to undertake this work
        clickOnThing($driver,'//label[contains(.,\'Why is it important to undertake this work\')]/following::div[1]', 'xpath');
	$temp_string ="The number of people diagnoses with neurodegenerative diseases is increasingly rapidly as the population ages. New methods to treat neurodegenerative diseases are urgently needed. This project examines a new potential therapeutic strategy that has the potential to slow progression of the disease.";	
	utf8::decode($temp_string);
	replaceTextInThing($driver, $temp_string);
        selectThing($driver,'//*[@id="permissible-purpose-basic-research"]');
        selectThing($driver, '//*[@id="permissible-purpose-translational-research"]');
        clickOnThing($driver,'//label[contains(.,\'Years\')]/following::option[7]', 'xpath');
        clickOnThing($driver,'//label[contains(.,\'Months\')]/following::option[1]', 'xpath');

        clickOnThing($driver,'summary', 'tag_name', 'Small');
        selectThing($driver,'//*[@id="species-mice"]');
        selectThing($driver,'//*[@id="species-ferrets"]');
        yesYesYes($driver, 1);
        return 1;

}


sub introductoryDetails
{
        my $driver = shift;
        my $textfile = shift;
        my $nonce = shift // "";
        
	clickOnThing($driver,  '//*[@id="title"]', 'xpath');
        my $title= someText(10, $textfile);
        replaceTextInThing($driver, $title);
	say STDERR "TITLE: ".$title;
        clickOnThing($driver, '//label[contains(.,\'aim of this project\')]/following::div[1]', 'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        
        ##Why is it important to undertake this work
        clickOnThing($driver,'//label[contains(.,\'Why is it important to undertake this work\')]/following::div[1]', 'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        selectThing($driver,'//*[@id="permissible-purpose-basic-research"]');
        clickOnThing($driver,'//label[contains(.,\'Years\')]/following::option[5]', 'xpath');
        clickOnThing($driver,'//label[contains(.,\'Months\')]/following::option[7]', 'xpath');
        
        clickOnThing($driver,'summary', 'tag_name', 'Small');
        selectThing($driver,'//*[@id="species-mice"]');
        yesYesYes($driver, 1); 
	return 1;
}

sub customExperience
{
	my $driver = shift;
        my $textfile = shift;

        clickOnThing($driver, 'a', 'tag_name', 'Experience');
        clickOnThing($driver,'label', 'tag_name', 'No');
my @questions = (
'What relevant scientific knowledge or education do you have',
'What experience do you have of using the types of animals and experimental models stated in this licence application',
'What experimental design and data analysis training have you had?',
'Why are you the most suitable person in the research group, department or company to manage the project?',
'What relevant expertise and staffing will be available to help you to deliver the programme of work?',
'Will other people help you manage the project? If so, how?');
my @answers = (
'I run have run a neurobiology group at the University of Reedville for 6 years using Drosophila models of neurodegeneration. Prior to that I have many years of post-doctoral experience in the same field.',
'I obtained my PIL A/B licence for mice in July 2017.',
'I have taken training courses in statistics during my post-doctoral experience at KCL. Experimental design and statistical methodology for animal experiments was part of my PPL training course at the University of Derickton in December 2017. My current research programme has required consultation on advance statistical methods with colleagues in the Clinical Trials unit at the University of Reedville, so I have existing local support where required.',
'My programme of research spans the fields of DNA damage and neurodegeneration. The preliminary data on which this project is based was generated by my group using Drosophila. This project is to validate the findings in a mammalian model as we push towards translation. The principal mouse line to be used in this project was generated and characterised by my long-term collaborator, Dr. Mamie Giles at KCL. I am the most suitable and obvious person to continue this collaboration. ',
'I have been working very closely with a colleague, Dr. Kevin Coventry, who is a Senior Lecturer in Neuroscience at the University of Reedville, on this project. Dr. Ahmed will train, certify and supervise me and the members of my group in the methods required for this project. A PhD student, Miss Charlotte George, and a post-doctoral fellow, Dr. Niki Anthoney, will be involved in the project. Both have recently obtained their PIL A/B licences. Additionally, Dr. Jonathan Lee, School of Psychiatry, University of Reedville, will assist in the training and certification for the memory tests to be used in this project.',
'Dr. Nelson Mcmillan will be centrally involved in the project. He will train, certify and supervise me. He has more than 20 years experience using rodent models for neurological disorders and is very familiar with every test to be used in this project.');

replaceTextInMultiple($driver, \@questions, '', \@answers);


        yesYesYes($driver);
        return 1;

}

sub experience
{
        my $driver = shift;
        my $textfile = shift;

        clickOnThing($driver, 'a', 'tag_name', 'Experience');
        clickOnThing($driver,'label', 'tag_name', 'Yes');
        clickOnThing($driver,
        '//label[contains(.,\'main achievements\')]/following::div[1]', 'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        clickOnThing($driver,
        '//label[contains(.,\'relevant expertise\')]/following::div[1]', 'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        clickOnThing($driver,
        '//label[contains(.,\'other people\')]/following::div[1]', 'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
	yesYesYes($driver);        
	return 1;
}

sub customFunding
{
        my $driver = shift;
        my $textfile = shift;

        ##### Funding
        clickOnThing($driver, 'a', 'tag_name', 'Funding');
        my @questions = (
	'How do you plan to fund your work?'
	);
	my @answers = (
	'This project is funded by a bequest to the University of Reedville. Sufficient funding is in place to for 24 months. I will apply for funding from Alzheimer’s Research UK interdisciplinary grant scheme with Nelson Mcmillan and Mamie Giles as co-applications for continued funding to support the work in early 2020 (application deadline July 2019). This application will fund the animal costs and a post-doctoral position. If the first stage is successful, larger applications to Alzheimer’s Research UK, the Motor Neuron Society or other neurodegeneration research charities will be submitted to fund the medium-term translational aims.');	
	replaceTextInMultiple($driver, \@questions, '', \@answers);
        yesYesYes($driver);
        return 1;
}

sub funding
{
        my $driver = shift;
        my $textfile = shift;
        
        ##### Funding
        clickOnThing($driver, 'a', 'tag_name', 'Funding');
clickOnThing($driver,
        '//label[contains(.,\'How do you plan to fund your work\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
	selectThing($driver, '//input[@type=\'radio\']', 'funding-basic-translational-true');
clickOnThing($driver,
        '//label[contains(.,\'peer\')]/following::div[1]'
        ,'xpath');
        replaceTextInThing($driver, someText(10, $textfile));
        yesYesYes($driver); 
        return 1;
} 

sub customEstablishments
{
	my $driver = shift;

##### Establishment
clickOnThing($driver, 'a', 'tag_name', 'Establishment');
selectThing($driver, '//*[@id="other-establishments-false"]');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

selectThing($driver,'//*[@id="establishments-care-conditions-true"]');
yesYesYes($driver);

 	return 1;
}

sub submitApplication
{
     my $driver = shift;
     my $textfile = shift;
     ## Avoid a pop up dialog by waiting a bit
     $driver->pause(5000);
     clickOnThing($driver, 'button', 'tag_name', 'Continue');
     selectThing($driver, '//*[@id="authority-yes"]');
     clickOnThing($driver, '//*[@id="authority-pelholder-name"]');
     replaceTextInThing($driver, someText(10, $textfile));
     clickOnThing($driver, '//*[@id="authority-endorsement-date"]');
     replaceTextInThing($driver, someText(10, $textfile));
     selectThing($driver, '//*[@id="awerb-yes"]');
     clickOnThing($driver, '//*[@id="awerb-review-date"]');
     replaceTextInThing($driver, someText(10, $textfile));
     selectThing($driver, '//*[@id="ready-yes"]');
     $driver->pause(5000);
     clickOnThing($driver, 'button', 'tag_name', 'Submit PPL application');
     $driver->pause(5000);
}

sub customPOLES
{
	my $driver = shift;
     	my $textfile = shift;
##### POLEs
clickOnThing($driver, 'a', 'tag_name', 'POLE');
selectThing($driver,'//*[@id="poles-true"]');
my @questions =("this part of your project take place at a licensed establishment?");
my @answers = ("Because I need feral ferrets.");
replaceTextInMultiple($driver, \@questions, '', \@answers);
clickOnThing($driver, 'button', 'tag_name', 'Continue');
selectThing($driver, '(//input[@type=\'text\'])', 'POLE.*title');
replaceTextInThing($driver, "South feral ferrets forest");

my @questions = ('Details');
my @answers = ('This is a POLE with lots of feral ferrets.');
replaceTextInMultiple($driver, \@questions, '', \@answers);

clickOnThing($driver, 'button', 'tag_name', 'Continue');
@questions = ('How will you ensure that procedures taking place at these POLEs can be inspected');
@answers = ('I will obtain consent from landowners and let the inspector know 2 days in advance.');
replaceTextInMultiple($driver, \@questions, '', \@answers);
selectThing($driver,'//*[@id="poles-transfer-false"]');
yesYesYes($driver);
	return 1;
}

sub customScientificBackground
{
        my $driver = shift;
        my $textfile = shift;
	clickOnThing($driver, 'a', 'tag_name', 'Scientific background');

	selectThing($driver,'//*[@id=\'scientific-background-basic-translational-true\']');
	selectThing($driver,'//*[@id=\'clinical-condition-false\']');
	selectThing($driver,'//*[@id=\'scientific-background-producing-data-false\']');
	selectThing($driver,'//*[@id=\'scientific-background-non-regulatory-false\']');
	selectThing($driver,'//*[@id=\'scientific-background-genetically-altered-false\']');
	selectThing($driver,'//*[@id=\'scientific-background-vaccines-false\']');
	selectThing($driver,'//*[@id=\'transfer-expiring-false\']');

	my @questions = (
'Briefly summarise the current state of scientific knowledge in this area of work to show how you arrived at the starting point of this project',
'What new knowledge do you hope to discover that will address a gap in fundamental scientific knowledge or meet a clinical need?'
);

my @answers = (
'DNA damage is a common feature of neurodegenerative diseases. Double-strand DNA breaks (DSBs), the most serious type of damage, accumulate in neurons and triggers the DNA damage response (DDR). Coupled with reduced capacity for the repair of DNA damage in neurons, this can lead to the persistent activation of the DDR, which can drive neurons to re-enter the cell cycle inappropriately and results in a senescence-like state or apoptosis.

We have identified using Drosophila models of neurodegeneration that inhibiting the DDR in the nervous system acts to protect the nervous system and maintains neural function for longer (1).
 This is true for Drosophila models of Alzheimer’s disease, frontotemporal dementia or Huntington’s disease. DNA damage is also a feature of acute neurotrauma and together with my colleague, Dr Nelson Mcmillan (UoB), we have identified that inhibiting the DDR is also neuroprotective in rat models of neurotrauma (Tuxworth et, al submitted to Brain, January 2019, (1).

Ref 1. Tuxworth, R.I. et al. (2019). Attenuating the DNA damage response to double strand breaks is neuroprotective. Submitted to Brain, January 2019. Preprint available at: https://www.biorxiv.org/content/10.1101/440636v1
2. Bondulich, M.K. et al. (2016). Tauopathy induced by low level expression of a human brain-derived tau fragment in mice is rescued by phenylbutyrate. Brain 139, 2290-306. PMID: 27297240
3. Dumon-Jones, V. et al (2003). Nbn heterozygosity renders mice susceptible to tumour formation and ionizing radiation-induced tumorigenesis. Cancer Res. 63, 7263-9. PMID: 14612522',

'Given the strong conservation of the DNA damage response between mammals and lower eukaryotes, we believe it is highly likely that the strategy of attenuating the response to DNA damage will also prove to be neuroprotective in human neurological disorders, including neurodegenerative disorders
. This project aims to show that the strategy is effective in a mouse model of Tauopathy. This will be the first step to developing this as a therapeutic strategy for human disorders.'
);
	replaceTextInMultiple($driver, \@questions, '', \@answers);
        yesYesYes($driver);
        return 1;
}

sub customActionPlan
{
	my $driver = shift;
        my $textfile = shift;

#### Action 
	say "ACTION";
	clickOnThing($driver, 'a', 'tag_name', 'Action');
	selectThing($driver, '(//input[@type=\'text\'])', 'objective.*title');
	## hold on to the objective so we can click on it later
	$objective1 = someText(10, $textfile);
	replaceTextInThing($driver, 'Determine whether attenuation of the DNA damage response in mouse models of neurodegeneration is neuroprotective');
        clickOnThing($driver, 'button', 'tag_name', 'Continue');
selectThing($driver,'//*[@id=\'objectives-regulatory-authorities-true\']');
	my @questions = 'Where relevant, how will you seek to use or develop non-animal alternatives for all or part of your work?';
	my @answers = 'The preliminary work used Drosophila models of neurodegeneration. To progress further towards a translational goal, mammalian models must now be used for validation.';
	replaceTextInMultiple($driver, \@questions, '', \@answers);
selectThing($driver,'//*[@id=\'objectives-regulatory-authorities-false\']');
selectThing($driver,'//*[@id=\'objectives-non-regulatory-false\']');
selectThing($driver,'//*[@id=\'objectives-genetically-altered-false\']');
selectThing($driver,'//*[@id=\'objectives-vaccines-false\']');
	yesYesYes($driver);
        return 1;

}
sub customGeneralPrinciples
{
	my $driver = shift;
        my $textfile = shift;
        say "GENERAL PRINCIPLES";
        clickOnThing($driver, 'a', 'tag_name', 'General principles');
        my @questions = (
	'Unnecessary duplication of work must be avoided. Under what circumstances would you knowingly duplicate work?',
'Why will you use animals of a single sex in some protocols or experiments?'
	);
	my @answers = (
	'',
	'The Tau35 transgene is inserted on the X chromosome. The original description and phenotyping of the Tau35 mouse by the Hanger group used only hemizygous males compared with wild-type males. It is unknown whether the pathology would present at a different time and progressive at a different rate in females. In order to show suppression of the pathology in the females when the DNA damage response is attenuated, I would first need to rigorously characterise the pathology. This will take approximately 3 years and would prevent the principal aim from being acheived.'
	);
        selectThing($driver,'//*[@id=\'experimental-design-sexes-false\']');
	## this should be true
        replaceTextInMultiple($driver, \@questions, '', \@answers);
        yesYesYes($driver);
	return 1;
}

sub customBenefits 
{
	my $driver = shift;
        my $textfile = shift;


	##### Benefits
	clickOnThing($driver, 'a', 'tag_name', 'Benefits');
	clickOnThing($driver, 'button', 'tag_name', 'Continue');
        selectThing($driver,'//*[@id=\'benefit-service-false\']');
	### This is wrong - this should be true
        my @questions = (
	'What outputs do you think you will see at the end of this project?',
	'Who or what will benefit from these outputs?',
	'How will you look to maximise the outputs of this work?'
        ); 
        my @answers = (
	'At the end of the project we will know whether attenuating the ability of the nervous system to sense damage to the nervous system can slow neurodegenerative diseases such as dementia in a mouse model. This will be lead to a publication regardless of outcome. Successful suppresion or slowing of disease will lead to further testing in other mouse models and, in the longer-term, a push towards therapy for human disease.',
	'We are in urgent need of therapies that can slow disease in neurodegeneration patients. If our project is successful, we will test other mouse models of neurodegeneration using methods that could also be used for treating human patients, such as gene therapy. Longer-term, if we can successfully slow the progression of disease in other models of neurodgeneration disorders, the same strategy could feasibly be tested in human patients with early-stage neurodegenerative disease. ',
	''
        );
        replaceTextInMultiple($driver, \@questions, '', \@answers);
	## click on the second "continue button on the page";
	yesYesYes($driver, 1);
	return 1;
}

sub customProjectHarms
{
	my $driver = shift;
        my $textfile = shift;
 	 
        clickOnThing($driver, 'a', 'tag_name', 'Project harms');
        clickOnThing($driver, 'button', 'tag_name', 'Continue');
        my @questions =(
	'Explain why you are using these types of animals and your choice of life stages.',
	'Typically, what will be done to an animal used in your project?',
	'What are the expected impacts and/or adverse effects for the animals during your project?',
	'What are the expected severities and the proportion of animals in each category (per animal type)?'
	);
	my @answers = (
	'',
	'Mice will be tested every 2-3 months for grip strength  and ability to walk on a rotating spindle. This will give a measure of how well their motor skills are functioning. They will also be tested for their ability to learn and remember spatial cues or the position of objects in a maze or test arena. These tests are non-invasive and require no drugs to be administered. ',
	'The mice will experience a low level of stress during the tests but this will cease once they are returned to their cages.',
	'While each test is of mild severity, the repeated tests every 2-3 months mean the tests overall will be considered moderate severity. All animals being tested will experience the moderate level of severity.'
	);
	replaceTextInMultiple($driver, \@questions, '', \@answers);
        ## click on the second "continue button on the page";
        yesYesYes($driver, 1);
        return 1;
}

sub customFateOfAnimals 
{
        my $driver = shift;
        my $textfile = shift;
	clickOnThing($driver, 'a', 'tag_name', 'Fate of animals');
	clickOnThing($driver, 'button', 'tag_name', 'Continue');
        selectThing($driver, '//*[@id="fate-of-animals-used-in-other-projects"]');
        yesYesYes($driver, 1);
        return 1;
}

sub customPurposeBredAnimals 
{
        my $driver = shift;
        my $textfile = shift; 
        clickOnThing($driver, 'a', 'tag_name', 'Purpose bred animals');
        selectThing($driver, '//*[@id="purpose-bred-true"]');
        yesYesYes($driver, 0);
        return 1;
}

sub customEndangeredAnimals 
{
        my $driver = shift;
        my $textfile = shift;
        clickOnThing($driver, 'a', 'tag_name', 'Endangered animals');
        selectThing($driver, '//*[@id="endangered-animals-false"]');
        yesYesYes($driver, 0);
        return 1;
}

sub customAnimalsTakeFromTheWild 
{
	my $driver = shift;
        my $textfile = shift;
        clickOnThing($driver, 'a', 'tag_name', 'Animals taken from the wild');
        selectThing($driver, '//*[@id="wild-animals-false"]');
	## click on the second "continue button on the page";
        yesYesYes($driver, 0);
        return 1;
}

sub customFeralAnimals
{
        my $driver = shift;
        my $textfile = shift;
        clickOnThing($driver, 'a', 'tag_name', 'Feral animals');
        selectThing($driver, '//*[@id="feral-animals-true"]');

	my @questions = (
	'you use non-feral animals to achieve your objectives?',
	'Why is the use of feral animals essential to protect the health or welfare of that species or to avoid a serious threat to human or animal health or the environment?',
	'Which procedures will be carried out on feral animals? And under which protocols?'
	);
	my @answers = (
	'Because we need feral ferrets.',
	'It is absolutely essential that we use feral ferrets.',
	'All the procedures, under all protocols.'
	);
	replaceTextInMultiple($driver, \@questions, '', \@answers);

        yesYesYes($driver);
        return 1;

}

sub customReUsingAnimals
{
        my $driver = shift;
        my $textfile = shift;
        clickOnThing($driver, 'a', 'tag_name', 'Re-using animals');
        selectThing($driver, '//*[@id="reusing-animals-false"]');
        yesYesYes($driver);
        return 1;
}

sub customCommercialSlaughter
{
        my $driver = shift;
        my $textfile = shift;
        clickOnThing($driver, 'a', 'tag_name', 'Commercial slaughter');
        selectThing($driver, '//*[@id="commercial-slaughter-false"]');
        yesYesYes($driver);
        return 1;
}


sub customAnimalsContainingHumanMaterial
{
         my $driver = shift;
         my $textfile = shift;

	clickOnThing($driver, 'a', 'tag_name', 'Animals containing human material');

	selectThing($driver, '//*[@id="animals-containing-human-material-true"]');
	yesYesYes($driver);
	return 1;
}

sub customReplacement
{
         my $driver = shift;
         my $textfile = shift;

clickOnThing($driver, 'a', 'tag_name', 'Replacement');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

my @questions = (
'Why do you need to use animals to achieve the aim of your project?',
'Which non-animal alternatives did you consider for use in this project?',
'Why were they not suitable?'
);
my @answers = (
'',
'The preliminary experiments for this project used fruit flies but, to see whether or not the same strategy might work in human neurodegenerative diseases, we first need to ask if it works in a mammalian model of disease. This is because, while the fruit fly brain is complex and controls complex behaviours, and while much of the biology of the fly brain is similar to humans, there is a big jump in the way the brains are structured. We cannot assume that we would see the same suppression of disease in humans that we do see in flies. Therefore, we need to test first in a mammalian model.',
'The brain controls the complex behaviours and physiology of an animal. These are progressively impacted by neurodegenerative disease. Simulating the basic biology of the disease in nerve cells grown in a dish or even in more complex brain organoids cannot tell us how the behaviour, memory function and social interactions will be affected. Therefore, we cannot know how our strategy would help prevent or slow the progressive neurodegenerative disease process unless we test it in a whole-animal model.'
);
replaceTextInMultiple($driver, \@questions, $textfile, \@answers);
yesYesYes($driver, 1);

return 1;
}


sub customReduction
{
	 my $driver = shift;
         my $textfile = shift;

clickOnThing($driver, 'a', 'tag_name', 'Reduction');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

selectThing($driver, '//input[@type=\'text\']', 'reduction.*quantities.*mice');
replaceTextInThing($driver, '500');
selectThing($driver, '//input[@type=\'text\']', 'reduction.*quantities.*ferrets');
replaceTextInThing($driver, '50');

my @questions = (
"How have you estimated the numbers of animals you will use",
"What steps did you take during the experimental design phase to reduce the number of animals being used in this project",
"What measures, apart from good experimental design, will you use to optimise the number of animals you plan to use in your project");

my @answers = (
'We have performed power calculations to determine the minimum number of mice required for each test. These are based on the previous description of the Tau35 mouse, which is the test model.',
'We have chosen to use only a core set of tests that should enable us to determine whether we can slow the rate of degeneration in the mice. We have chosen not repeat all tests used in the original description of the Tau35 mouse to reduce the numbers that must be bred for the project.',
'Initial tests will provide us with a measure of the variability. If required, we will modify the number of animals required for a successful outcome of the project by repeating power calculations at this stage.'
);
replaceTextInMultiple($driver, \@questions, $textfile, \@answers);
yesYesYes($driver, 1);

return 1;
}

sub customRefinement
{
 	my $driver = shift;
        my $textfile = shift;
        say "Refinement";
        clickOnThing($driver, 'a', 'tag_name', 'Refinement');
        clickOnThing($driver, 'button', 'tag_name', 'Continue');
        my @questions = (
'Which animal models and methods will you use during this project?',
'How will you refine the procedures you',
'What published best practice guidance will you follow to ensure experiments are conducted in the most refined way?'
        );
        my @answers = (
'We will use a mouse model of a human form of dementia, known as progressive supranuclear palsy (PSP). This is one of a group of related neurodegenerative disorders known as the Tauopathies. It has overlapping symptoms and shares some of the underlying biology with Alzheimer\'s disease and other dementias. The mouse model of PSP we will use, called Tau35, develops disease more slowly than many other mouse models of dementia. This potentially means it is a better model of the slowly progressing, late-onset human disease.

The Tau35 mouse starts to have motor problems from about 4 months of age. These are reduced grip strength, reduced ability to stay on a rotating spindle and clapsing of the limbs. We will look to see whether these are improved by reducing the ability of the mouse to act on DNA damage in the nervous system. The tests are non-invasive, involve administering no drugs and cause little stress or suffering the mouse.

The Tau35 mouse also shows a progressive reduction in spatial learning and memory skills. We will ask whether spatial memory if improved using two learning tasks: the T-maze and novel object recognition. Unlike the commonly used water maze, these are non-swimming based and therefore reduce the stress on the mouse.',

'The tests of motor function and of spatial learning and memory are non-invasive and produce little stress on the mouse. Mice will be handled daily in the 5-7 days preceeding the tests to reduce stress and also habituated to the testing arenas to reduce stress. Animals will be monitored at all times for signs of stress and will not be tested if considered stressed. Examples of this will include ensuring each mouse explores the T-maze when placed in it: a mouse stationary for 90 secs and not exploring will be returned to its home cage and tested later.

Tests of the Tau35 mice will be conducted at 3, 6, 8, 10 and 12 months of age. By reducing the frequency of testings at early ages reduces the total from 6 tests to 5 tests to reduce cumulative stress.

We will be able to determine whether the rate of disease progression in the Tau35 has been slowed by 12 months of age. Therefore, after the 12-month testing is completed, the mice will be humanely killed. 
This is to prevent the progressive neurodegenerative disease from impacting further on the health of the mice as they age.',

'What published best practice guidance will you follow to ensure experiments are conducted in the most refined way?' 
        );
        replaceTextInMultiple($driver, \@questions, '', \@answers);
        yesYesYes($driver, 1);
        return 1;

}

sub customReview
{
        my $driver = shift;
        my $textfile = shift;
	clickOnThing($driver, 'a', 'tag_name', 'Review');
	selectThing($driver, '//*[@id="complete-true"]');
	clickOnThing($driver, 'button', 'tag_name', 'Continue');
        return 1;
}


sub customFillInPPL
{
	my $driver = shift;
        my $textfile = shift;
        my $nonce = shift;
        my $filename = "tmp.png";
        assert_true(customIntroductoryDetails($driver, $textfile, $nonce), "Introductory Details");
        assert_true(customExperience($driver, $textfile), "Experience");
        assert_true(customFunding ($driver, $textfile), "Funding");
        assert_true(customEstablishments ($driver, $textfile), "Establishments");
	assert_true(customPOLES ($driver, $textfile), "POLES");
        assert_true(customScientificBackground ($driver, $textfile), "Scientific Background");
        assert_true(customActionPlan ($driver, $textfile), "Action Plan");
        assert_true(customGeneralPrinciples ($driver, $textfile), "General Principles");
        assert_true(customProjectHarms ($driver, $textfile), "Project harms");
        assert_true(customBenefits ($driver, $textfile), "Benefits");
	assert_true(customAddProtocol1 ($driver, $textfile), "Add Protocol 1");
	##assert_true(customAddProtocol2 ($driver, $textfile), "Add Protocol 2");
	assert_true(customFateOfAnimals ($driver, $textfile), "Fate of animals");
	assert_true(customPurposeBredAnimals ($driver, $textfile), "Purpose bred animals");
	assert_true(customEndangeredAnimals ($driver, $textfile), "Endangered animals");
	assert_true(customAnimalsTakeFromTheWild ($driver, , $textfile), "Animals Taken From the Wild");
	assert_true(customFeralAnimals ($driver, , $textfile), "Feral Animals");
        assert_true(customReUsingAnimals($driver, , $textfile), "ReUsingAnimals");
        assert_true(customCommercialSlaughter($driver, $textfile), "Commercial slaughter");
	assert_true(customAnimalsContainingHumanMaterial ($driver, $textfile), "Animals containing human material");
	assert_true(customReplacement ($driver, $textfile), "Replacement");
        assert_true(customReduction ($driver, $textfile), "Reduction");
	assert_true(customRefinement ($driver, $textfile), "Refinement");
        assert_true(customReview($driver, $textfile), "Review");
}

sub fillInPPL
{
	my $driver = shift;
        my $textfile = shift;
        my $nonce = shift;
	my $filename = "tmp.png";
        assert_true(introductoryDetails($driver, $textfile, $nonce), "Introductory Details");
        assert_true(experience($driver, $textfile), "Experience");
        assert_true(funding ($driver, $textfile), "Funding");

##### Establishment
clickOnThing($driver, 'a', 'tag_name', 'Establishment');
selectThing($driver, '//*[@id="other-establishments-false"]');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

selectThing($driver,'//*[@id="establishments-care-conditions-false"]');
clickOnThing($driver,
'//label[contains(.,\'If any establishment does not meet these requirements\')]/following::div[1]', 'xpath');
replaceTextInThing($driver, someText(10, $textfile));

yesYesYes($driver);
#####goto FATE_OF_ANIMALS;
##### POLEs
clickOnThing($driver, 'a', 'tag_name', 'POLE');
selectThing($driver,'//*[@id="poles-true"]');
my @questions=("this part of your project take place at a licensed establishment?");
my @answers = ("Because I need feral ferrets.");
replaceTextInMultiple($driver, \@questions, '', \@answers);
clickOnThing($driver, 'button', 'tag_name', 'Continue');
selectThing($driver, '(//input[@type=\'text\'])', 'POLE.*title');

replaceTextInThing($driver, someText(10, $textfile));

clickOnThing($driver,
'//label[contains(.,\'Details\')]/following::div[1]',
'xpath');
replaceTextInThing($driver, someText(10, $textfile));

clickOnThing($driver, 'button', 'tag_name', 'Continue');
clickOnThing($driver,
'//label[contains(.,\'How will you ensure that procedures taking place at these POLEs can be inspected\')]/following::div[1]',
'xpath');
replaceTextInThing($driver, someText(10, $textfile));
selectThing($driver,'//*[@id="poles-transfer-true"]');

clickOnThing($driver,
'//label[contains(.,\'Why do you need to move animals between a POLE and a licensed establishment\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

clickOnThing($driver,
'//label[contains(.,\'How will you ensure that animals are in a suitable condition to be transported\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

clickOnThing($driver,
'//label[contains(.,\'Who will be responsible for checking the animals before they are transported\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

clickOnThing($driver,
'//label[contains(.,\'How will you ensure that this person is competent to make the appropriate checks\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

clickOnThing($driver,
'//label[contains(.,\'How might the movement of animals between a POLE and a licensed establishment affect the scientific delivery of this project\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

clickOnThing($driver,
'//label[contains(.,\'What arrangements will be made to assure an animal\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));
clickOnThing($driver, 'button', 'tag_name', 'Continue');
selectThing($driver,'//*[@id="complete-true"]');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

SCIENTIFIC_BACKGROUND:
#### Scientific Background
say "SCIENTIFIC_BACKGROUND";
clickOnThing($driver, 'a', 'tag_name', 'Scientific Background');
selectThing($driver,'//*[@id=\'scientific-background-basic-translational-true\']');
selectThing($driver,'//*[@id=\'clinical-condition-true\']');
selectThing($driver,'//*[@id=\'scientific-background-producing-data-true\']');
selectThing($driver,'//*[@id=\'scientific-background-producing-data-service-true\']');
selectThing($driver,'//*[@id=\'scientific-background-non-regulatory-true\']');
selectThing($driver,'//*[@id=\'scientific-background-non-regulatory-condition-true\']');
selectThing($driver,'//*[@id=\'scientific-background-genetically-altered-true\']');
selectThing($driver,'//*[@id=\'scientific-background-vaccines-true\']');
selectThing($driver,'//*[@id=\'transfer-expiring-true\']');

my @questions = (
'Briefly summarise the current state of scientific knowledge in this area of work to show how you arrived at the starting point of this project',
'How prevalent and severe are the relevant clinical conditions?',
'How will these products benefit human health, animal health, or the environment?',
'How will you select the most appropriate scientific model or method?',
'In general terms, how will those using your service use the data that your produce?',
'In general terms, how will those using your service use the product?',
'In general terms, how will your clients use the data or other outputs that you produce?',
'Please state the licence number and expiry date of all these licences',
'What are the likely demands for the products over the lifetime of the project?',
'What are the likely demands for the service over the lifetime of the project?',
'What are the problems with current treatments which mean that further work is necessary?',
'What is the nature of the service you wish to provide?',
'What is the scientific basis for your proposed approach?',
'What new knowledge do you hope to discover that will address a gap in fundamental scientific knowledge or meet a clinical need?',
'What products do you wish to provide?',
'What service do you wish to provide?',
'What substances or devices will undergo regulatory testing?',
'Who will you provide a service to?',
'Who will you provide the service to?',);

replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver);

ACTION:
#### Action 
say "ACTION";
clickOnThing($driver, 'a', 'tag_name', 'Action');
selectThing($driver, '(//input[@type=\'text\'])', 'objective.*title');
## hold on to the objective so we can click on it later
$objective1 = someText(10, $textfile);
replaceTextInThing($driver, $objective1);

clickOnThing($driver,
'//label[contains(.,\'How do each of these objectives relate to each other and help you to achieve your aim\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

clickOnThing($driver, 'button', 'tag_name', 'Add another objective');
selectThing($driver, '(//input[@type=\'text\'])', 'objective.*title', 1);
$objective2 = someText(10, $textfile);
replaceTextInThing($driver, $objective2);

clickOnThing($driver, 'button', 'tag_name', 'Continue');

clickOnThing($driver,
'//label[contains(.,\'animal alternatives for all or part of your work\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

yesYesYes($driver);

GENERAL:
### General
say "GENERAL";

clickOnThing($driver, 'a', 'tag_name', 'General');
clickOnThing($driver,
'//label[contains(.,\'Unnecessary duplication of work must be avoided\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

selectThing($driver,'//*[@id="experimental-design-sexes-false"]');

clickOnThing($driver,
'//label[contains(.,\'Why will you use animals of a single sex in some protocols or experiments\')]/following::div[1]',
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

yesYesYes($driver);


##### Benefits
clickOnThing($driver, 'a', 'tag_name', 'Benefits');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

clickOnThing($driver,
'//label[contains(.,\'What outputs do you think you will see at the end of this project\')]/following::div[1]'
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));
clickOnThing($driver,
'//label[contains(.,\'Who or what will benefit from these outputs\')]/following::div[1]'
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));
clickOnThing($driver,
'//label[contains(.,\'How will you look to maximise the outputs of this work\')]/following::div[1]'
,'xpath');
replaceTextInThing($driver, someText(10, $textfile));

## click on the second "continue button on the page";
yesYesYes($driver, 1);

##### Protocols
clickOnThing($driver, 'a', 'tag_name', 'Protocols');

## is there a protocol already?
if (!isOnPage($driver,'Completed'))
{
   #### add a protocol
   addProtocol($driver, $textfile, $objective1, 1);
   #### clickOnThing($driver, 'a', 'tag_name', 'Protocols');
   #### addProtocol($driver, $textfile, $objective2, 2);
}
else
{
   yesYesYes($driver,1);
}

PROJECT_HARMS:
clickOnThing($driver, 'a', 'tag_name', 'Project harms');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

my @questions = (
"Explain why you are using these types of animals and your choice of life stages", 
"what will be done to an animal used in your project", 
"What are the expected impacts and",
"What are the expected severities and the proportion of animals in each category" );

replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver, 1);
FATE_OF_ANIMALS:
##### Fate of Animals
clickOnThing($driver, 'a', 'tag_name', 'Fate of animals');

clickOnThing($driver, 'button', 'tag_name', 'Continue');

selectThing($driver, '//*[@id="fate-of-animals-nts-true"]');

@questions =
("What types of animals will you keep alive",
"What criteria will the veterinary surgeon, or competent person trained by a veterinary surgeon, use to determine whether animals can be kept alive",
"under the supervision of the veterinary surgeon");

replaceTextInMultiple($driver, \@questions, $textfile);

selectThing($driver, '//*[@id="fate-of-animals-set-free"]');

@questions = ("health be assessed to determine whether it can be set free");
replaceTextInMultiple($driver, \@questions, $textfile);

selectThing($driver, '//*[@id="fate-of-animals-rehomed"]');

@questions = (
"What types of animals do you intend to",
"health allows it to be rehomed",
"How will you ensure that rehoming does not pose a danger to public health, animal health, or the environment",
"What scheme is in place to ensure socialisation when an animal is rehomed",
"wellbeing when it is rehomed"
);
replaceTextInMultiple($driver, \@questions, $textfile);

selectThing($driver, '//*[@id="fate-of-animals-used-in-other-projects"]');
clickOnThing($driver, '//button[text()=\'Continue\']','xpath','', 1);
selectThing($driver, '//*[@id="complete-true"]');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

clickOnThing($driver, 'a', 'tag_name', 'Purpose bred animals');

selectThing($driver, '//*[@id="purpose-bred-false"]');
@questions = ("Where will you obtain non-purpose bred animals from",
"you achieve your objectives by only using purpose bred animals");
replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver);

clickOnThing($driver, 'a', 'tag_name', 'Endangered animals');
selectThing($driver, '//*[@id="endangered-animals-true"]');
@questions = ("you achieve your objectives without using endangered animals",
"Explain how the project is for one of the permitted purposes");
replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver);

clickOnThing($driver, 'a', 'tag_name', 'Animals taken from the wild');
selectThing($driver, '//*[@id="wild-animals-true"]');
@questions = ("you achieve your objectives without using animals taken from the wild",
"How will these animals be captured",
"How will you minimise potential harms when catching these animals");

replaceTextInMultiple($driver, \@questions, $textfile);

selectThing($driver, '//*[@id="non-target-species-capture-methods-true"]');
@questions = ('How will you minimise the risk of capturing non-target animals, including strays and animals of a different sex?',
"How will you ensure the competence of any person responsible for the capture of animals",
'How will you examine any animals that are found to be ill or injured at the time of capture');
replaceTextInMultiple($driver, \@questions, $textfile);

selectThing($driver, '//*[@id="wild-animals-vet-false"]');
@questions = ("How will you ensure the competence of the person responsible for making this assessment");

replaceTextInMultiple($driver, \@questions, $textfile);

selectThing($driver, '//*[@id="wild-animals-poor-health-true"]');

clickOnThing($driver, 'button', 'tag_name', 'Continue');
selectThing($driver, '//*[@id="wild-animals-marked-true"]');

@questions = (
'If sick or injured animals are to be treated, how will you transport them for treatment?',
'If sick or injured animals are to be humanely killed, which methods will you use?',
'How will animals be identified?'
);
replaceTextInMultiple($driver, \@questions, $textfile);

selectThing($driver, '//*[@id="wild-animals-devices-true"]');
$driver->pause(1000);
@questions = (
'How will any adverse effects from a device',
'How will you locate and recapture the animals or otherwise ensure the devices are removed at the end of the regulated procedures?',
'If animals will not have devices removed, what are the potential effects on them, other animals, the environment and human health?'
);
replaceTextInMultiple($driver, \@questions, $textfile);

selectThing($driver, '//*[@id="wild-animals-declaration-true"]');
yesYesYes($driver);

clickOnThing($driver, 'a', 'tag_name', 'Feral animals');
selectThing($driver, '//*[@id="feral-animals-true"]');
@questions = (
"feral animals to achieve your objectives",
"Why is the use of feral animals essential to protect the health or welfare of that species or to avoid a serious threat to human or animal health or the environment",
"Which procedures will be carried out on feral animals");

replaceTextInMultiple($driver, \@questions, $textfile);


yesYesYes($driver);

clickOnThing($driver, 'a', 'tag_name', 'Re-using animals');
@questions = (
"Why do you intend to re-use animals",
"What are the limitations on re-using animals for this project");

replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver);


clickOnThing($driver, 'a', 'tag_name', 'Commercial slaughter');
selectThing($driver, '//*[@id="commercial-slaughter-true"]');

@questions = (
"How will you ensure that these animals are healthy and meet commercial requirements for meat hygiene to enable them to enter the food chain");
replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver);


####clickOnThing($driver, 'a', 'tag_name', 'Neuromuscular blocking agents');
####
####@questions = ("Why do you need to use NMBAs in your protocols",
####"What anaesthetic and analgesic regime will you use",
####"How will you ensure that animals have adequate ventilation",
####"and distress for an animal under the influence of an NMBA");
####
####replaceTextInMultiple($driver, \@questions, $textfile);

#### clickOnThing($driver, 'button', 'tag_name', 'Continue');

####@questions = ("How will you monitor the depth of anaesthesia",
####"How will you ensure there are sufficient staff present throughout the use of NMBAs",
####"Explain the agreed emergency routine at your establishment that covers potential hazardous events");

####replaceTextInMultiple($driver, \@questions, $textfile);
####yesYesYes($driver);

####clickOnThing($driver, 'a', 'tag_name', 'Re-using animals');

####selectThing($driver, '//*[@id="reusing-animals-true"]');

####@questions = ("What types of animals will you be re",
####"Why do you intend to re",
####"What are the limitations on re-using animals for this project");

####replaceTextInMultiple($driver, \@questions, $textfile);
####yesYesYes($driver);

clickOnThing($driver, 'a', 'tag_name', 'Animals containing human material');

selectThing($driver, '//*[@id="animals-containing-human-material-true"]');
yesYesYes($driver);

clickOnThing($driver, 'a', 'tag_name', 'Replacement');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

@questions = (
"Why do you need to use animals to achieve the aim of your project",
"animal alternatives did you consider for use in this project",
"Why were they not suitable");

replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver, 1);

clickOnThing($driver, 'a', 'tag_name', 'Setting animals free');

selectThing($driver, '//*[@id="setting-free-vet-false"]');

@questions = (
"s health be assessed to determine whether it can be set free",
"How will you ensure that setting animals free will not be harmful to other species, the environment, and human health",
"Will you rehabilitate animals before setting them free",
"Will you attempt to socialise any animals that you have set free",
"How will you prevent inadvertent re-use of animals that have been released at the end of procedures",
"If animals are lost to the study or not re-captured, how will you determine whether your project is complete",
"How will you ensure the competence of the person responsible for assessing whether animals can be set free");

replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver);

clickOnThing($driver, 'a', 'tag_name', 'Rehoming');
@questions = (
"What types of animals do you intend to rehome",
"s health allows it to be rehomed",
"How will you ensure that rehoming does not pose a danger to public health, animal health, or the environment",
"What scheme is in place to ensure socialisation when an animal is rehomed",
"What other measures will you take to safeguard an animal");

replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver);


clickOnThing($driver, 'a', 'tag_name', 'Reduction');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

selectThing($driver, '//input[@type=\'text\']', 'reduction.*quantities');
replaceTextInThing($driver, '100');

@questions = (
"How have you estimated the numbers of animals you will use",
"What steps did you take during the experimental design phase to reduce the number of animals being used in this project",
"What measures, apart from good experimental design, will you use to optimise the number of animals you plan to use in your project");

replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver, 1);

clickOnThing($driver, 'a', 'tag_name', 'Refinement');
clickOnThing($driver, 'button', 'tag_name', 'Continue');

@questions = (
"Which animal models and methods will you use during this project",
'How will you refine the procedures you',
"What published best practice guidance will you follow to ensure experiments are conducted in the most refined way"
);

replaceTextInMultiple($driver, \@questions, $textfile);
yesYesYes($driver, 1);

clickOnThing($driver, 'a', 'tag_name', 'Review');
selectThing($driver, '//*[@id="complete-true"]');
$driver->execute_script('window.confirm = function(msg) { return true; }');

clickOnThing($driver, 'button', 'tag_name', 'Continue');

$driver->execute_script('window.confirm = function(msg) { return true; }');

##clickOnThing($driver, 'a', 'tag_name', 'Word');
##clickOnThing($driver, 'a', 'tag_name', 'Backup');
submitApplication($driver, $textfile);

}


1;
