#!/bin/bash

# install dos2unix using homebrew
#brew install dos2unix


for i in $(seq 1 5047);
do
   dos2unix CAMP_SEQ$i.html;
done # converts all the files from DOS to unix

# series of bash scripts to parse html files for building flat file DB for query

## to parse CAMP_SEQ series
#
# to get the species of origins
export LC_CTYPE=C
export LANG=C

## to get species
grep -A 1 "Source" *.html|grep "left"| sed -e 's/^[ \t]*//g' -e 's/<td align="left">//g' -e 's|</td>||g' > temp.txt # temp file for storing the data
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/-/,/g' -e 's/\[[^]]*\]//g'> ./curated-CAMP/camp_seq_species.txt
rm temp.txt # clears the temp file, the species of origin for the CAMP seq are found in camp_seq_species.txt

## to get sequence
grep "fasta" *html|grep "justify"| sed -e  's/<td colspan="2" align="justify" class="fasta">//' -e 's|<br></td>||g'>temp.txt #temp file only
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/:/,/g' -e 's/<br>//g'> ./curated-CAMP/camp_seq_sequence.txt
rm temp.txt # CAMP sequences are found in camp_seq_squence.txt

## to get length
grep -A 1 "Length" *.html|grep "left"| sed -e 's/^[ \t]*//g' -e 's/<td align="left">//g' -e 's|</td>||g' > temp.txt # temp file for storing the data
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/-/,/g' -e 's/\[[^]]*\]//g'> ./curated-CAMP/camp_seq_length.txt
rm temp.txt

## to get the NCBI references::
grep -A 1 "pubmed" *html| sed -e 's/^[ \t]*//g' -e 's/<td align="left"><a href=//g' -e 's/<[^>]*>//g'>temp.txt
cat temp.txt| tr -s ' '|sed -e 's/, [ 0-9 ]* target=_blank>.*//g'| sed -e 's/CAMP_SEQ[0-9]*.html-//g' -e 's/--//g'  -e 's/,[ 0-9 ]*//g' -e 's/.html:/ /g' -e 's/target=_blank.*//g' >./curated-CAMP/camp_seq_ref.txt # references file; to be added to the flatfile

~/Desktop/lsm3241-git/src/bash/wget_pubmeds_camp_seq.sh # runs bash script for getting pubmed records

rm temp.txt  # removes our temp file

## to generate separate list for easy manipulation in R
# read into R with readLines
# list of index for sequence and species
cd ./curated-CAMP/ # goes to the directory where all the flat files are stored..
cut -d "," -f2- camp_seq_species.txt > camp_seq_species_id.txt
cut -d "," -f1 camp_seq_species.txt > camp_seq_species_index.txt
cut -d "," -f2- camp_seq_sequence.txt > camp_seq_sequence_id.txt
cut -d "," -f1 camp_seq_sequence.txt > camp_seq_sequence_index.txt
cut -d "," -f2- camp_seq_length.txt > camp_seq_length_id.txt
cut -d "," -f1 camp_seq_length.txt > camp_seq_length_index.txt

# to run with R
R CMD BATCH ../R/construct_flat_seq.R # R stout output will be stored in construct_flat_seq.Rout in the source directory


