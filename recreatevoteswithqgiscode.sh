#!/bin/bash

while read line
do 
	search=`echo $line | awk -F"," {'print $2'}`
	found=`grep "$search" qgisvaluesforjoin.csv | awk -F"," {'print $1'}`
	echo "$line,$found"
done < votes.csv
