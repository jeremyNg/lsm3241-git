#!/bin/bash

echo $(pwd)
cd ..
echo $(pwd)
mkdir DATA/camp_SEQ_data_html
cd DATA/camp_SEQ_data_html
echo $(pwd)
url=http://www.camp.bicnirrh.res.in/seqDisp.php?id=CAMPSQ
for i in $(seq 5041 5048);
do
wget $url$i -O CAMP_SEQ$i.html;
sleep 1
done
