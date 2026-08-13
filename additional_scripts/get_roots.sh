#!/bin/bash

usage(){
    #Help message for the script
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
        #Sets -d to FILE. This is the directory containing the FASTQ files.

    -o|--out)
        [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
        OUT="$2" 
        shift 2 ;;
        #Sets -o to OUT. This is the ouput file.


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


# Output file
TEMP="roots.tmp"

# Loop through matching files
for file in "$DIR"*.fastq.gz; do
    BASE=$(basename "$file") # Remove folder path
    ROOT="${BASE%%_R*}" 
    echo "$ROOT" >> "$TEMP" #Writes ROOT to TEMP
done

awk 'NR % 2 == 0' $TEMP > $OUT #Keeps only every second line of the files

rm $TEMP #Removes TEMP

echo "Roots written to $OUT"
