#!/bin/bash

FILE=/share/hoverflies/Caleb/ragtag/ragtag.scaffold.fasta
OUT=/share/hoverflies/Caleb/alt_chr_list.txt

grep "^>" $FILE | grep -o '>[^ ]*' > $OUT
