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
	#Help message for the script
	echo "Usage: sbatch [slurm-options] $0 [options]"
	echo
	echo "slurm-options:"
	echo "  --array=			Array range for the number of samples"
	echo
	echo "Options:"
	echo "  -q, --fastq		Input FASTQ directory"
	echo "  -o, --out			Output directory"
	echo "  -n, --names		A .txt file containg the names of the fastq files"
	echo "  -h, --help		Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
		-q|--fastq)
	  	[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
	  	SAMPLE_DIR="$2"
	  	shift 2 ;;
	  	# Sets -q to $SAMPLE_DIR. Should be a directory for the fastq files

		-o|--out)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			OUT="$2" 
			shift 2 ;;
			# Sets -o to $OUT. Should be the output directory

		-n|--names)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			NAME_FILE="$2" 
			shift 2 ;;
			# Sets -n to $NAME_FILE. Should be a .txt file with the names of all the files in $SAMPEL_DIR

		-h|--help)
			usage
			exit 0
			;;
			# Runs usage

		*) echo "Invalid option: $1" 
			exit 1 ;;
			# Error handling for incorrect options
  esac
done


mapfile -t NAMES < $NAME_FILE
#Reads .txt file from $NAME_FILE and assigns to $NAME

mkdir -p $OUT
#Makes output dir

SAMPLE=$SAMPLE_DIR${NAMES[$SLURM_ARRAY_TASK_ID]} #Makes smaple name for arrays

# Running QC Analysis
fastqc \
 -t 8 \
 "$SAMPLE" \
 -o "$OUT"
#Runs fastqc using 8 cores
