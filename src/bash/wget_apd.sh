#!/bin/bash

cd ~/Desktop/lsm3241-misc/data/APD_html
url=http://aps.unmc.edu/AP/database/query_output.php?ID=

for i in $(seq -w 2339 2383);
do
    wget $url$i -O APD_$i.html;
    sleep 0.5;
done
