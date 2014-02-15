#!/bin/bash

# series of bash scripts to parse html files for building flat file DB for query

# to parse CAMP_SEQ series
# to get the species of origins
export LC_CTYPE=C
export LANG=C
# to get species
grep -A 1 "Source" *.html|grep "left"| sed -e 's/^[ \t]*//g' -e 's/<td align="left">//g' -e 's|</td>||g' > temp.txt # temp file for storing the data
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/-/,/g' -e 's/\[[^]]*\]//g'> camp_seq_species.txt
rm temp.txt # clears the temp file, the species of origin for the CAMP seq are found in camp_seq_species.txt
# to get sequence
grep "fasta" *html|grep "justify"| sed -e  's/<td colspan="2" align="justify" class="fasta">//' -e 's|<br></td>||g'>temp.txt #temp file only
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/:/;/g' -e 's/<br>//g'> camp_seq_sequence.txt
rm temp.txt # CAMP sequences are found in camp_seq_squence.txt
# to get length
grep -A 1 "Length" *.html|grep "left"| sed -e 's/^[ \t]*//g' -e 's/<td align="left">//g' -e 's|</td>||g' > temp.txt # temp file for storing the data
cat temp.txt| tr -s ' '|sed -e 's/.html//g' -e  's/-/,/g' -e 's/\[[^]]*\]//g'> camp_seq_length.txt
rm temp.txt

# to generate separate list for easy manipulation in R
# read into R with readLines
# list of index for sequence and species
cut -d "," -f2- camp_seq_species.txt > camp_seq_species_id.txt
cut -d "," -f1 camp_seq_species.txt > camp_seq_species_index.txt
cut -d ";" -f2- camp_seq_sequence.txt > camp_seq_sequence_id.txt
cut -d ";" -f1 camp_seq_sequence.txt > camp_seq_sequence_index.txt
cut -d "," -f2- camp_seq_length.txt > camp_seq_length_id.txt
cut -d "," -f1 camp_seq_length.txt > camp_seq_length_index.txt

R CMD BATCH ../R/construct_flat_seq.R

# R output will be stored in construct_flat_seq.Rout


