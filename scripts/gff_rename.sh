#!/bin/bash

cd /share/hoverflies/Caleb/references

awk 'BEGIN{FS=OFS="\t"}
FNR==NR {map[$1]=$2; next}
(/^#/){print; next}
{$1 = ($1 in map ? map[$1] : $1); print}
' chrom_map.txt GCA_949129095.1_idVolBomb1.1_genomic.gff > test.gff