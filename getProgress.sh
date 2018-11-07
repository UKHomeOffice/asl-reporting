#! /bin/bash
myPath='./graphs/'
sudo rm -r $myPath"*_files"
myPrefix='progress'
mySuffix='.html'
myDatFile=$myPath"progress.dat"
myDate=`date +%Y%m%d`

myFile="$myPath$myPrefix$myDate$mySuffix" 
rm $myFile

# To Do 
save_page_as "https://jira.digital.homeoffice.gov.uk/issues/?jql=Project%20%3D%20%22Animal%20Sciences%22%20and%20status%20not%20in%20(%22In%20Progress%22%2C%20Done%2C%20Cancelled%2C%20Archived)%20and%20labels%20!%3D%20%22Risk%22&startIndex=50" -b  firefox -d $myFile
toDo=`perl progress.pl $myFile`
rm $myFile
# Doing
save_page_as "https://jira.digital.homeoffice.gov.uk/issues/?jql=Project%20%3D%20%22Animal%20Sciences%22%20and%20status%20in%20(%22In%20Progress%22)%20and%20labels%20!%3D%20%22Risk%22" -b  firefox -d $myFile
doing=`perl progress.pl $myFile`
rm $myFile
# Done
save_page_as "https://jira.digital.homeoffice.gov.uk/issues/?jql=Project%20%3D%20%22Animal%20Sciences%22%20and%20status%20in%20(Done)%20and%20labels%20!%3D%20%22Risk%22
" -b  firefox -d $myFile
done=`perl progress.pl $myFile`
rm $myFile

echo $myDate $done     $doing     $toDo >> $myDatFile
sort $myDatFile | uniq > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile
### put a header at the top of the file
echo "### Done Doing ToDo" > $myDatFile.$$
cat $myDatFile >> $myDatFile.$$ && mv $myDatFile.$$ $myDatFile
