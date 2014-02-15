#!/bin/bash

# for peptaibol
grep -A 1 "Reference" *.html| sed '/\<h3\>Refe/d'|sed 's/<UL><LI>//'>~/Desktop/lsm3241-src/peptaibol_references.txt # will export a txt file of only peptaibol reference list

