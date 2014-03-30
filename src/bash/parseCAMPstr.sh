#!/bin/bash
# scripts to parse sequences


grep -A 5 Sequence *.html|grep -A 3 fasta|sed -e 's/<[^>]*>//g' -e 's/--//g' -e '/^\s*$/d'|perl -lape 's/-\s*/|/sg'|grep '|[A-Z]'>extracted/Sequences.txt # Gets a list of all sequences with a '|' delimiter

grep -A 2 Length *html|grep -v Length|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*"left">//g' -e 's/<.*>//g'|perl -lape 's/-\s*/|/sg'|grep 'html|[0-9]'>extracted/sequenceLengths.txt # extracts a list of all the lengths of sequences to extracted/sequenceLengths.txt, with a '|' delimiter

grep -A 1 Source *html|grep -v Source|sed -e 's/--//g' -e '/^\s*$/d'|perl -lape 's/html-\s*/html|/sg'|sed -e 's/<.*"left">//g' -e 's/<.*//g'>extracted/Species.txt # gets a list of all the species, with a '|' delimiter

grep -A 1 UniProt *html|grep -v UniProt| sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*blank>//g' -e 's/<.*//g'|perl -lape 's/html-\s*/html|/sg'>extracted/UniProts.txt # gets UniProt Id, with a '|' delimiter

grep -A 1 PubMed *html| grep -v PubMed| sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*term=//g' -e 's/target.*//g'|perl -lape 's/html-\s*/html|/sg'>extracted/PubMeds.txt # extracts all the pubmed IDs to the file extracted/Pubmeds.txt with a '|' delimiter 

grep -A 1 Activity *html|grep -v Activity|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*"left">//g' -e 's/<.*//g'| perl -lape 's/html-\s*/html|/sg'|grep Anti>extracted/Activity.txt # extracts activity of AMP with a '|' delimiter. Hemolytic activity was not extracted 

grep -A 1 Experimental *html|grep -v Experimental|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<t.*left">//g' -e 's/<.*//g'|perl -lape 's/html-\s*/html|/sg'>extracted/Validation.txt # gets  a list of structural validation method

grep -A 1 PDB *html|grep -v PDB|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<t.*Id=//g' -e 's/target.*//g'|perl -lape 's/html-\s*/html|/sg'|grep '|[0-9]'>extracted/PDBs.txt # gets a list of all PDB files

