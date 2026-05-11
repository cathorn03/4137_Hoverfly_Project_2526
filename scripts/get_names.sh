#!/bin/bash

#Path to fastqs
FQ_PATH=/share/hoverflies/fastqs/

# Output file
OUT="names.txt" > "$OUT"  # Clear file if it exists

# Loop through matching files
for file in "$FQ_PATH"*.fastq.gz; do
    BASE=$(basename "$file")      # Remove folder path
    echo "$BASE" >> "$OUT"
done

echo "Names written to $OUT"
