#!/bin/bash

cd ../../DATA/raw/
mkdir APD_html
cd APD_html

url=http://aps.unmc.edu/AP/database/query_output.php?ID=

for i in $(seq -w 1 2338);
do
    wget $url$i -O APD_$i.html;
    sleep 0.5;
done
