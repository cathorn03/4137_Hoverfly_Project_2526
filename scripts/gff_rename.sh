#!/bin/bash

cd /share/hoverflies/Caleb/references

awk 'BEGIN{FS=OFS="\t"}
NR==FNR {map[$1]=$2; next}
$0 !~ /^#/ {$1=map[$1]}
{print}' ../chrom_map.txt GCA_949129095.1_idVolBomb1.1_genomic.gff > test.gff