#!/bin/bash

mkdir ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/pubmeds
cp ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/camp_seq_ref.txt ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/pubmeds

cd ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/pubmeds

awk '{print "wget -O " $1 ".html " $2}' camp_seq_ref.txt>temp.txt
sed '/wget -O .html/d' temp.txt> wgetcall.txt

while read line;
do
`$line`;
sleep 0.5;
done < wgetcall.txt # performs the wget
