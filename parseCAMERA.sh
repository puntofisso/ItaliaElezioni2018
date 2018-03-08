#!/bin/bash


#Camera,01110000000,colleggioUninominale,LI,,24-20180304000000-3456-0.png,PARTITO DEMOCRATICO,,34629,"28,54",,,34629,"28,54",
echo "Downloading"
rm -f scrutiniCI_u.csv
rm -f CAMERA_CU.csv
wget https://raw.githubusercontent.com/ondata/elezionipolitiche2018/master/dati/scrutiniCI_u.csv

echo "Parsing and extracting"
grep "colleggioUninominale,LI" scrutiniCI_u.csv > CAMERA_CU.csv.tmp
while read line
do
	code=`echo $line | awk -F"," {'print $2'}`
	party=`echo $line | awk -F"," {'print $7'}`
	votes=`echo $line | awk -F"," {'print $9'}`
	echo "$code,$party,$votes" >> CAMERA_CU.csv
done < CAMERA_CU.csv.tmp
rm -f CAMERA_CU.csv.tmp

echo "Generating simplified votes file"
rm -f votes.csv
while read line
do
        code=`echo $line | awk -F"," {'print $1'}`
        party=`echo $line | awk -F"," {'print $2'}`
        votes=`echo $line | awk -F"," {'print $3'}`

        name=`grep $code enti.csv | awk -F"," {'print $2'}`

        echo "$code,$name,$party,$votes" >> votes.csv

done < CAMERA_CU.csv

echo "Generating party list"
rm -f parties.csv
cat votes.csv | awk -F"," {'print $3'} | sort | uniq > parties.csv

echo "Generating files by single party"
mkdir -p votesbyparty
rm -f votesbyparty/*.csv
while read partyname
do
        grep "$partyname" votes.csv > "votesbyparty/$partyname.csv"
done < parties.csv
