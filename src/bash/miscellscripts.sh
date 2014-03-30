# Miscellaneous scripts

cat AMPs.txt| awk -F'\t' '{print ">"$2 "\n" $6}'>new.fasta # makes a fasta file
formatdb -p T -i new.fasta #formats the fasta file to be blastable
