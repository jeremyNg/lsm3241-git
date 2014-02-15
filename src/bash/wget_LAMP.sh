LC_CTYPE=C && LANG=C # set some language parameter in the env, else sed will encounter problems due to encoding 

# fasta file contains all the sequences in fasta format, to parse the fasta to only get the IDs, then after to generate urls for wget, which pipes to a new file, urls.txt
cat lamp_fasta.fasta|grep "L0*" lamp_fasta.fasta|grep -v ^[A-Z]|sed 's/>//'|sed 's/\|*//'|sed 's|^\(..........\).*|\1 http://biotechlab.fudan.edu.cn/database/lamp/detail.php?id=\1|'>urls.txt

awk '{print "wget -O " $1 ".html " $2}' urls.txt | while read line ; do `$line` ;sleep 0.5;done # performs the wget

