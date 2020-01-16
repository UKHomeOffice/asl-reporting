#! /bin/bash
myPath='./graphs/'
sudo rm -r graphs/burnupChart*files
myPrefix='newburn'
defaultOutputFile='file.svg'
defaultOutputSuffix='.svg'
mySuffix='.json'
myDatFile=$myPath"newburn.dat"
myDate=`date +%Y%m%d`
echo $myDate
myFile="$myPath$myPrefix$myDate$mySuffix" 
myDefaultOutputFile="$myPath$myPrefix$myDate$defaultOutputSuffix" 
rm $myFile

save_page_as https://trello.com/b/KpVVpCty.json -b  firefox -d $myFile

perl roadmapJSON2.pl $myFile | tail -n 1 >> $myDatFile

sort $myDatFile > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile

## this removes duplicate lines (I think)
perl -ne '/(\d+)\s+(\d+)$/; print unless $a{$1}++' $myDatFile > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile

totalBacklog=`tail -n 1 ${myDatFile} | perl -ne '/(\d+)$/; print $1'`
echo $totalBacklog

gnuplot -e "datafile='${myDatFile}'" $myPath"dateFit.gnu" 
 
cp $defaultOutputFile $myDefaultOutputFile;
