#! /bin/bash
myPath='./graphs/'
##sudo rm -r "$myPath*_files"
sudo rm -r graphs/burnupChart*files
myPrefix='burnupChart'
mySuffix='.html'
myDatFile=$myPath"burnupchart.dat"
myDate=`date +%Y%m%d`
echo $myDate
myFile="$myPath$myPrefix$myDate$mySuffix" 
rm $myFile

save_page_as https://trello.com/b/EmrhbGKu.json -b  firefox -d $myFile

perl getJSONBurnup.pl $myFile | tail -n 1 >> $myDatFile

##sort $myDatFile | uniq > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile
sort $myDatFile > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile

perl -ne '/(\d+)\s+(\d+)$/; print unless $a{$1}++' $myDatFile > $myDatFile.$$ && mv $myDatFile.$$ $myDatFile

totalBacklog=`tail -n 1 ${myDatFile} | perl -ne '/(\d+)$/; print $1'`
echo $totalBacklog

gnuplot -e "datafile='${myDatFile}'; backlog=${totalBacklog}" $myPath"dateFit.gnu" 
 

