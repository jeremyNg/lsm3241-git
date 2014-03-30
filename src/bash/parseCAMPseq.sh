#!/bin/bash

# script to parse CAMPSeq HTML files
# the following data will be extracted as follows
# 0- AMP Name
# 1- CAMP_SEQ ID, to be changed to CAMPSQ
# 2- Sequence
# 3- Length of Sequence
# 4- Species of origin
# 5- Activity
# 6- UniProt
# 7- PubMed

cd ~/Desktop/lsm3241-misc/data/camp_SEQ_data_html # changes the present working directory
mkdir extracted  # create a directory for all the extracted data to be stored

grep -A 1 Title *html|grep -v Title|sed -e 's/--//g' -e '/^\s*$/d' -e 's/html-/html|/g' -e 's/<.*"left">//g' -e 's/<.*//g'|perl -lape 's/|\s*//sg'#>extracted/campName.txt # gets a list of all the AMP name from the title field, stored in a file with the '|' delimited

ls *.html|sed -e 's/CAMP_SEQ/CAMPSQ/g' >extracted/campids.txt # gets a list of all the CAMP IDs

cat extracted/campids.txt|wc -l # counts how many records do we have in all our HTML files

grep -A 5 Sequence *.html|grep -A 3 fasta|sed -e 's/<[^>]*>//g' -e 's/--//g' -e '/^\s*$/d'|perl -lape 's/-\s*/|/sg'|grep '|[A-Z]'>extracted/sequences.txt # extracts a list of all the sequences to the file extracted/sequences.txt, where the sequence is separated by the delimiter '|'

grep -A 2 Length *html|grep -v Length|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*"left">//g' -e 's/<.*>//g'|perl -lape 's/-\s*/|/sg'|grep 'html|[0-9]'>extracted/sequenceLengths.txt # extracts a list of all the lengths of sequences to extracted/sequenceLengths.txt, with a '|' delimiter

cat extracted/sequences.txt|wc -l # counts how many records of sequences do we have; 7 samples without recorded sequences
cat extracted/sequenceLengths.txt|wc -l # counts how many records of sequences do we have; 7 samples without recorded sequences

grep -A 1 Source *html|grep -v Source|sed -e 's/--//g' -e '/^\s*$/d'|perl -lape 's/html-\s*/html|/sg'|sed -e 's/<.*"left">//g' -e 's/<.*//g'>extracted/Species.txt # gets a list of all the species, with a '|' delimiter

cat extracted/Species.txt|wc -l # Check the number of records in the species file, there are 7 missing records

grep -A 1 'NCBI Tax' *html|grep -v NCBI|sed -e 's/--//g' -e 's/<.*blank>//g' -e 's/<.*//g' -e '/^\s*$/d'|perl -lape 's/html-\s*/html|/sg'>extracted/NCBItaxonomy.txt # gets a list of all NCBI taxonomy number in the records with a '|' delimiter

grep -A 1 UniProt *html|grep -v UniProt| sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*blank>//g' -e 's/<.*//g'|perl -lape 's/html-\s*/html|/sg'>extracted/UniProts.txt # gets UniProt Id, with a '|' delimiter

grep -A 1 PubMed *html| grep -v PubMed| sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*term=//g' -e 's/target.*//g'|perl -lape 's/html-\s*/html|/sg'|preg -v '</tr>'>extracted/PubMeds.txt # extracts all the pubmed IDs to the file extracted/Pubmeds.txt with a '|' delimiter

grep -A 1 GenInfo *html| grep -v GenInfo|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*blank>//g' -e 's/<.*//g'|perl -lape 's/html-\s*/html|/sg'>extracted/GenInfo.txt # gets all the GenInfo identifier, with a '|' delimiter

grep -A 1 Activity *html|grep -v Activity|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*"left">//g' -e 's/<.*//g'| perl -lape 's/html-\s*/html|/sg'|grep Anti>extracted/Activity.txt # extracts activity of AMP with a '|' delimiter. Hemolytic activity was not extracted

grep -A 1 Target *html|grep -v Target|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*left">//g' -e 's/<.*//g'|perl -lape 's/html-/html|/sg'>extracted/targets.txt # extracts a list of all AMP targets

grep -A 1 Validated *html|grep "left"|sed -e 's/<.*left">//g' -e 's/<.*//g'|perl -lape 's/html.\s*/html|/sg'>extracted/Validation.txt # extracts a list of validation status in a '|' delimited file
