#!/bin/bash
# TODO
# To get more information on the biochemistry of the AMP
# should be sufficient for my non-redundant database
#scripts to parse APD records
grep -A 1 Name *html|grep -v Name|sed -e 's/--//g' -e '/^\s*$/d' |grep '<p>'|sed -e 's/<.*<p>//g' -e 's/<.*//g' -e 's/(.*)//g'|perl -lape 's/html-\s*/html|/sg'>extracted/Names.txt # get names of the records

grep -A 4 Sequence *html|grep font|sed -e 's/<.*3300">//g' -e 's/<.*//g'|perl -lape 's/html-\s*/html|/sg'>extracted/Sequences.txt # parses the sequence information

grep -A 1 Length *html|grep -v Length|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*<p>//g' -e 's/<.*//g'|perl -lape 's/html-\s*/html|/sg'>extracted/SequenceLength.txt # gets sequence length information

grep  SwissProt *html|grep href|sed -e 's/&.*//g'|perl -lape 's/html:\s*/html|/sg'>extracted/UniProt.txt # gets the UniProt IDs with '|' delimiter

grep  -A 1 Reference *html|grep href|sed -e 's|<.*pubmed/||g' -e 's/">.*//g'|perl -lape 's/html-\s*/html|/sg'>extracted/PubMeds.txt # gets the pubmed IDs

grep -A 1 Activity *html|grep -v Activity|grep -v '&nbsp'|sed -e 's/<.*<p>//g' -e 's/Fungi/Antifungal/g' -e 's/, <.*//g' -e 's/--//g' -e '/^\s*$/d' -e 's/,<.*//g' -e 's/Cancer cells/Anticancer/g' -e 's/Virus/Antiviral/g' -e 's/<.*//g' -e 's/Gram+/Antibacterial/g' -e 's/Gram-/Antibacterial/g' -e 's/Antibacterial & Antibacterial/Antibacterial/g' -e 's/Parasites/Antiparasitic/g' -e 's/HIV/Antiviral (HIV)/g'|perl -lape 's/html-\s*/html|/sg'>extracted/activity.txt # gets the activity, a few substitutions were made -> cancer to anticancer, fungal to antifungal, conflation of gram + and gram - bacteria 

grep -A 1 Additional *html|grep -v Additional|sed -e 's/--//g' -e '/^\s*$/d' -e 's/<.*<p>//g' -e 's|</td>||g'|perl -lape 's/html-\s*/html|/sg'>extracted/AdditionalInfo.txt # gets the additional information if available with a '|' delimited file
