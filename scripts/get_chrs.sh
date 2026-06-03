#!/bin/bash

FILE=/share/hoverflies/Caleb/references/GCA_949129105.1_idVolBomb1.1_alternate_haplotype_genomic.fasta
OUT=/share/hoverflies/Caleb/alt_chr_list.txt

grep "^>" $FILE | grep -o '>[^ ]*' > $OUT
