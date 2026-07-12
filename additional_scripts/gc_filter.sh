#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64g
#SBATCH --time=1:00:00
#SBATCH --job-name=GC_filter
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-1

source $HOME/.bash_profile
conda activate hoverflies

usage(){
	#Help message for the script
	echo "Usage: sbatch [slurm-options] $0 [options]"
	echo
	echo "Options:"
	echo "  -f, --fastq	Directory containing the FASTQ files"
	echo "  -n, --names	File containging the name and extension of the FASTQS of interest"
	echo "  -m, --min-GC	The minmum value of GC content to be filtered for"
	echo "  -M, --max-GC	The maximum value of GC content to be filtered for" 
	echo "  -o, --out		Output directory"
	echo "  -h, --help	Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in

    -f|--fastq-files)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      FQ_DIR="$2" 
      shift 2 ;;

    -n|--names-file)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      NAMES_FILE="$2" 
      shift 2 ;;

    -m|--min-GC)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MIN_GC="$2"
      shift 2 ;;

    -M|--max-GC)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MAX_GC="$2"
      shift 2 ;;

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT_DIR="$2" 
      shift 2 ;;

    -h|--help)
      usage
      exit 0
      ;;

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done


mapfile -t NAMES < $NAMES_FILE
#Maps the names file to a list variable

SAMPLE_NAME=${NAMES[$SLURM_ARRAY_TASK_ID]}
#Sets file for the array 

SAMPLE_gz=$FQ_DIR$SAMPLE_NAME
#Creates full path for the inout file

SAMPLE_ROOT=$(basename $SAMPLE_NAME .fastq.gz)
#Creates a root for the input file by removing the file path
OUT_NAME=${SAMPLE_ROOT}".filtered.fasta"
#Creates output file name

gunzip -c $SAMPLE_gz > $OUT_DIR$SAMPLE_ROOT".fastq"
#Unzips the fastq file and outputs it to the output directory

SAMPLE=$OUT_DIR$SAMPLE_ROOT".fastq"
#Sets the unzipped fastq file

echo "$SAMPLE_NAME filtered by GC"

OUT=$PATH_TO/Caleb/high_GC/$OUT_NAME
#Sets output file path

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
#Calls path to this script
SCRIPT=$SCRIPT_DIR/gc_filter.py
#Gives the file path to the python script

python $SCRIPT $SAMPLE $MIN_GC $MAX_GC > $OUT
#Runs gc_filter.py

rm $OUT_DIR$SAMPLE_ROOT".fastq"
#Removes unzipped fastq file
