#!/bin/bash

usage(){
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

grep "^>" $FILE | grep -o '>OX[^ ]*' | sed 's/^>//' | paste -sd, - > $OUT
