#!/bin/bash

cd /share/hoverflies/Caleb/references

awk '
BEGIN {
    FS=OFS="\t"
    while ((getline < "chrom_map.txt") > 0)
        map[$1]=$2
}
$0 ~ /^#/ { print; next }
$1 in map { $1=map[$1] }
{ print }
' GCA_949129095.1_idVolBomb1.1_genomic.gff > test.gff