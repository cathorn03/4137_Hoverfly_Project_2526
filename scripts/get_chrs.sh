#!/bin/bash

FILE=/share/hoverflies/Caleb/references/GCA_949129095.1_idVolBomb1.1_genomic.fna
OUT=/share/hoverflies/Caleb/chr_list.txt

grep "^>" $FILE | grep -o '>[^ ]*' > $OUT
