#!/bin/bash

mkdir ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/pubmeds
cp ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/camp_seq_ref_id.txt ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/pubmeds

cd ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html/pubmeds

awk 'print{wget -O" $1 $1"}'camp_seq_ref_id.txt| while read line;
do
`$line`;
sleep 0.5;
done # performs the wget
