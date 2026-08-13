#!/bin/bash

usage(){
    #Help message for the script
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -d, --directory   Path to the directory containing the bam files"
    echo "  -o, --out         Output file"
    echo "  -h, --help        Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in

    -d|--directory)
        [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
        BAM="$2"
        shift 2 ;;
        #Sets -d to BAM. This is the directory containing the BAM files.

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

# Loop through matching files and writes them to OUT.
for file in "$BAM"*.rmd.bam; do
    echo "$file" >> "$OUT"
done

echo "BAMS written to $OUT"     
