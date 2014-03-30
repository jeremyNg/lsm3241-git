#!/bin/bash

# TODO- 
#PubMed parsing
#Parsing to get detailed function
#Source/Species needs to be manually parsed to remove all the additional stuff that are not needed
#Get the other miscellaneous chemical properties as well

# scripts to parse LAMP database
ls *html|wc -l # gets the number of records 
grep Name *html|sed -e 's/<.*p;Name://g' -e 's/<.*//g'|grep -v nbsp|perl -lape 's/html:/html|/sg'>extracted/Names.txt # gets a list of all the names, with a'|' delimiter

grep Sequence *html| sed -e 's/&nbsp;//g' -e 's/<.*Sequence<br>//g' -e 's/<.*//g' -e 's/html:/html|/g'|grep '|[A-Z]'>extracted/Sequences.txt # gets all the sequences in a '|' delimited file

cat extracted/Sequences.txt|wc -l # check to see how many sequences were extracted

grep Source *html|sed -e 's/&nbsp;//g' -e 's/<.*Source://g' -e 's/<.*//g' -e 's/html:/html|/g' >extracted/Source.txt # gets a list of all the sources in a '|' file

grep Length *html|sed -e 's/&nbsp;//g' -e 's/<.*Length://g' -e 's/<.*//g' -e 's/html:/html|/g'|grep '|[ 0-9 ]'>extracted/SequenceLengths.txt # gets the sequence length

grep uniprot *html|sed -e 's/&nbsp;//g' -e 's|<.*uniprot/||g' -e 's/>.*//g' -e 's/html:/html|/g'>extracted/UniProt.txt # gets uniprot IDs with '|' delimiter

grep PubMed *html|sed -e 's/&nbsp;//g' -e 's/<.*PubMed://g' -e 's/\].*//g'|grep -v '<' > extracted/PubMeds.txt # gets PubMeds # NB: Parsing is not thorough, some other pubmed IDs are buried, but only managed to get 1 each only 

grep Function *html|sed -e 's/&nbsp;//g' -e 's/<.*Function://g' -e 's/<.*//g' -e 's/html:/html|/g'|grep 'html|[A-Z]'>extracted/Function.txt # gets a list of all functions with a '|' delimiter

grep Activity *html|sed -e 's/&nbsp;//g' -e 's/<.*Activity://g' -e 's/<.*//g' -e 's/html:/html|/g' -e 's/,,,/,/g' -e 's/,,/,/g'|grep 'html|[A-Z]'>extracted/Activity.txt # gets a list of all activity in a '|' file







