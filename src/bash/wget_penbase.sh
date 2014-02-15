#!/bin/bash

wget http://penbase.immunaqua.com/List.php?ListPen=Search&page=data

grep "List2.php$pep" List.php\?ListPen\=Search|sed 's/<td width="150" align="left">//g'|cut -d ">" -f1|sed 's/<a href="//g'|sed 's/"//g' >ids

awk '{print "wget " $1 ".html"}' ids|while read line; do `$line`; sleep 0.5;done
