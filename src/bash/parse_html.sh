#!/bin/bash

# series of bash scripts to parse html files for building flat file DB for query
# brew install dos2unix # install dos2unix using homebrew


export LC_CTYPE=C
export LANG=C

############################################################################
# TO DO:
############################################################################

########################################################################################################################################################
## to parse CAMP_SEQ series

for i in $(seq 1 5047);
do
   dos2unix CAMP_SEQ$i.html;
done # converts all the files from DOS to unix

mkdir curated-CAMP # makes a directory where the processed data will be stored

# Chunk 1: Species of origin of the AMP
#Species of origin for the CAMP seq are found in camp_seq_species.txt in the curated data folder
grep -A 1 "Source" *.html|grep "left"| sed -e 's/^[ \t]*//g' -e 's/<td align="left">//g' -e 's|</td>||g' > temp.txt # temp file for storing the data
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/-/,/g' -e 's/\[[^]]*\]//g'> ./curated-CAMP/camp_seq_species.txt
rm temp.txt # clears the temp file
# End C1 #

# Chunk 2: To get AMP sequence
# CAMP sequences are found in camp_seq_squence.txt
grep "fasta" *html|grep "justify"| sed -e  's/<td colspan="2" align="justify" class="fasta">//' -e 's|<br></td>||g'>temp.txt #temp file only
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/:/,/g' -e 's/<br>//g'> ./curated-CAMP/camp_seq_sequence.txt
rm temp.txt
# End C2 #

## Chunk 3: To get AMP length
# Length stored in camp_seq_length.txt
grep -A 1 "Length" *.html|grep "left"| sed -e 's/^[ \t]*//g' -e 's/<td align="left">//g' -e 's|</td>||g' > temp.txt # temp file for storing the data
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/-/,/g' -e 's/\[[^]]*\]//g'> ./curated-CAMP/camp_seq_length.txt
rm temp.txt
# End C3 #

# C4: To get AMP activity
grep -A 1 "Activity" *.html| sed -e 's/<[^>]*>//g' -e 's/^[\t]*//g'| grep "Anti" >temp.txt # temp.txt needs to be parsed in R::
awk '{print $1 }' temp.txt| sed 's/"//g'| sed 's/.html-//g' > ./curated-CAMP/activityindex.txt
awk '{print $2 $3 $4}' temp.txt| sed 's/"//g' > ./curated-CAMP/activity.txt
rm temp.txt
# End C4 #

## to generate separate list for easy manipulation in R ##
# Scripts for parsing prior to submission into R scripts #

cd ./curated-CAMP/ # goes to the directory where all the flat files are stored

# each file will be split into 2 files- one for the index (CAMP ID) and the other for the corresponding values (Seq, Length, Species)
# Separating will make working in R easier, each file will be read in via readLines()
cut -d "," -f2- camp_seq_species.txt > camp_seq_species_id.txt
cut -d "," -f1 camp_seq_species.txt > camp_seq_species_index.txt
cut -d "," -f2- camp_seq_sequence.txt > camp_seq_sequence_id.txt
cut -d "," -f1 camp_seq_sequence.txt > camp_seq_sequence_index.txt
cut -d "," -f2- camp_seq_length.txt > camp_seq_length_id.txt
cut -d "," -f1 camp_seq_length.txt > camp_seq_length_index.txt

########################################################################################################################################################

########################################################################################################################################################
# to parse LAMP series of data
mkdir curated-LAMP
grep "Source" *.html|sed -e 's/^.*Source://g' -e 's/<.*//g'>./curated-LAMP/species.txt # parses out for the species of each lamp name
ls *html|sed -e 's/.html//g'>./curated-LAMP/index.txt # list of all the IDs:

grep "Length" *.html|sed -e 's/^.*Length://g' -e 's/<.*//g'>./curated-LAMP/sequencelength.txt # gets the length of aa sequence
grep "Length" *.html|sed -e 's/^.*Sequence<br>//g' -e 's/<.*//g' -e 's/[&nbsp;]*//g'>./curated-LAMP/sequences.txt # gets the aa sequence
# there is a file with a funny new line- we will parse it with R in the R codes
grep "Activity" *.html| grep "nbsp"|sed -e 's/^.*Activity:/Activity:/g'| sed 's/<.*//g' >./curated-LAMP/activity.txt # to get activity of AMP

# to run with R to make the flatfile
R CMD BATCH ../R/construct_flat_seq.R # R stout output will be stored in construct_flat_seq.Rout in the source directory

sed -i' ' 's/Activity://g' merged.txt # Fix a parsing error:: LAMP database will show Activity: Anti , which is inconsistent with CAMP structure 
