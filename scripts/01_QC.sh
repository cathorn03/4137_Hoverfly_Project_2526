#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=01_fastqc
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-86

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

usage(){
	echo "Usage: $0 [options]"
	echo
	echo "Options:"
	echo "  -q, --fastq    Input FASTQ directory"
	echo "  -n, --names    A .txt file containg the names of the fastq files"
	echo "  -o, --out      Output directory"
	echo "  -h, --help     Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  	-q|--fastq)
	  	[[ -z "$2" ]] && { echo "Missing argument for $1"; exit 1; }
	  	SAMPLE_DIR="$2"
	  	shift 2 ;;

	-o|--out)
		[[ -z "$2" ]] && { echo "Missing argument for $1"; exit 1; }
		OUT="$2" 
		shift 2 ;;

	-n|--names)
		[[ -z "$2" ]] && { echo "Missing argument for $1"; exit 1; }
		NAME_FILE="$2" 
		shift 2 ;;

	-h|--help)
		usage()
		exit 0
		;;
		
	*) echo "Invalid option: $1" 
		exit 1 ;;
  esac
done

mapfile -t NAMES < $$NAME_FILE
#Reads names.txt and assigns to $NAME
#names.txt contains the names of all fastq files in /share/hoverflies/fastqs/

mkdir -p $OUT
#Makes output dir

SAMPLE=$SAMPLE_DIR${NAMES[$SLURM_ARRAY_TASK_ID]} #Makes smaple name for arrays

# Running QC Analysis
fastqc \
 -t 8 \
 "$SAMPLE" \
 -o "$OUT"
#Runs fastqc
