#!/bin/bash
cd ..
cd DATA/
mkdir camp_STR_data_html
cd camp_STR_data_html

for i in $(seq 1 682);
do
    wget http://www.camp.bicnirrh.res.in/jmol/strDisp.php?id=CAMPST$i -O camp_STR$i.html;
done
