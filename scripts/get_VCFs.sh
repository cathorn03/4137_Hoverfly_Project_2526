#!/bin/bash

#Path to fastqs
VCF_PATH=/share/hoverflies/Caleb/VCF/

# Output file
OUT=/share/hoverflies/Caleb/vcf_list.txt

# Loop through matching files
for file in "$VCF_PATH"*.vcf.gz; do
    echo "$file" >> "$OUT"
done

echo "VCFs written to $OUT"  
