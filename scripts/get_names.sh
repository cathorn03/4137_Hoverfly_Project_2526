#!/bin/bash

usage(){
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -d, --directory    Path to the directory containing the fastq files"
    echo "  -o, --out          Output file"
    echo "  -h, --help         Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
        -d|--directory)
            [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
            DIR="$2"
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

# Loop through matching files
for file in "$DIR"*.fastq.gz; do
    BASE=$(basename "$file")      # Remove folder path
    echo "$BASE" >> "$OUT"
done

echo "Names written to $OUT"
