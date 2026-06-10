#!/bin/bash

usage(){
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -d, --directory    Path to file containg fastqs"
    echo "  -o, --out          Output file"
    echo "  -h, --help         Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
        -d|--directory)
            [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
            FILE="$2"
            shift 2 ;;

        -o|--out)
            [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
            OUT="$2" 
            shift 2 ;;

        -h|--help)
            usage
            exit 0
            ;;

        *) echo "Invalid option: $1" 
            exit 1 ;;
  esac
done


# Output file
TEMP="roots.tmp"

# Loop through matching files
for file in "$DIR"*.fastq.gz; do
    BASE=$(basename "$file") # Remove folder path
    ROOT="${BASE%%_R*}" 
    echo "$ROOT" >> "$TEMP"
done

awk 'NR % 2 == 0' $TEMP > $OUT

rm $TEMP

echo "Roots written to $OUT"
