#!/bin/bash

usage(){
    #Help message for the script
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
        #Sets -d to DIR. This is the directory containing the files to extract the names of

    -o|--out)
        [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
        OUT="$2" 
        shift 2 ;;
        #Sets -o to OUT. This is the ouput file

    -h|--help)
        usage
        exit 0
        ;;
        #Runs usage

    *) echo "Invalid option: $1" 
        exit 1 ;;
        #Error handling for incorrect options
  esac
done

# Loop through matching files
for file in "$DIR"*.fastq.gz; do
    BASE=$(basename "$file") #Removes folder path
    echo "$BASE" >> "$OUT" #Writes file name to OUT
done

echo "Names written to $OUT"
