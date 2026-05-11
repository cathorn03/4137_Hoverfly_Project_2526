#!/bin/bash

FILE=./references/GCA_949129095.1_idVolBomb1.1_genomic.fna
OUT=chr_list.txt

grep "^>OX" $FILE | grep -o 'OX[^ ]*' > $OUT
