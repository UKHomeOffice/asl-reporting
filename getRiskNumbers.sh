#! /bin/bash
myPath='./graphs/'
sudo rm -r "$myPath*_files"
myPrefix='risk'
mySuffix='.html'
myDatFile=$myPath"risk.dat"
myDate=`date +%Y%m%d`
echo $myDate
myFile="$myPath$myPrefix$myDate$mySuffix" 
rm $myFile

while tail -n 1 $myDatFile | grep -Fq $myDate 
do
## shorten the bottom of the file by one
head -n -1 $myDatFile > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile
done


save_page_as https://trello.com/b/VuFuCL7t.json -b  firefox -d $myFile

perl riskJSON.pl $myFile | tail -n 1 >> $myDatFile

sort $myDatFile | uniq > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile

perl -ne '/(\d+)\s+(\d+)$/; print unless $a{$1}++' $myDatFile > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile
totalBacklog=`tail -n 1 ${myDatFile} | perl -ne '/(\d+)$/; print $1'`
echo $totalBacklog
