#!/bin/bash

#Path to fastqs
FQ_PATH=/share/hoverflies/Caleb/BAM/

# Output file
OUT="bam_list.txt" > "$OUT"  # Clear file if it exists

# Loop through matching files
for file in "$FQ_PATH"*.rmd.bam; do
    echo "$file" >> "$OUT"
done

echo "BAMS written to $OUT"     
