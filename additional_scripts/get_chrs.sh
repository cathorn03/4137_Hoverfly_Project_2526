#!/bin/bash

usage(){
	#Help message for the script
	echo "Usage: $0 [options]"
	echo
	echo "Options:"
	echo "  -f, --reference    Input reference file as a fasta"
	echo "  -o, --out          Output file"
	echo "  -h, --help         Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
		-f|--reference)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			FILE="$2"
			shift 2 ;;
			#Stes -f to FILE. This should be the FASTA file to extract chromsomes from.

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

grep "^>" $FILE | grep -o '>OX[^ ]*' | sed 's/^>//' | paste -sd, - > $OUT
#Searches file for lines starting with > in FILE
#Then looks for header lines starting with ">OX" and returns that line until theres a space
#Removes the starting >
#Joins the lines in the file with commas
#Writes it to out

