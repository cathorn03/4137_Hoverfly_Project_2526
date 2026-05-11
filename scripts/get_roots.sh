#!/bin/bash

#Path to fastqs
FQ_PATH=/share/hoverflies/fastqs/

# Output file
TEMP="roots.tmp"
OUT="roots.txt" > "$OUT"  # Clear file if it exists

# Loop through matching files
for file in "$FQ_PATH"*.fastq.gz; do
    BASE=$(basename "$file") # Remove folder path
    ROOT="${BASE%%_R*}" 
    echo "$ROOT" >> "$TEMP"
done

awk 'NR % 2 == 0' $TEMP > $OUT

rm $TEMP

echo "Roots written to $OUT"
