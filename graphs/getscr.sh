#!/bin/sh



# read URLs from a data file in a loop
count=1
while read url
do
	    # send URL to the firefox session
	        firefox $url&

		    # take a picture after waiting a bit for the load to finish
		        sleep 5
			    gnome-screenshot -B -w *firefox* -f image$count.jpg

			        count=`expr $count + 1`
			done < url_list.txt
pkill -f firefox
