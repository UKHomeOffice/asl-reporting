#! /usr/bin/bash
for x in $(ls -1rt roadmap*dat); do 
	echo $x
	cat $x
done

