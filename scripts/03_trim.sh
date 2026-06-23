#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=03_trim
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-42

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
	echo "  -r, --roots		A .txt file containg the roots of the fastq files"
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
			OUT_DIR="$2" 
			shift 2 ;;
			# Sets -o to $OUT_DIR. Should be the output directory

		-r|--roots)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			ROOT_FILE="$2" 
			shift 2 ;;
			# Sets -r to $ROOT_FILE. Should be a .txt file containing the roots of all the files in $SAMPLE_DIR
			# The file should contain sample names for samples in $SAMPLE_DIR without read direction and file extension
			# e.g. /share/hoverflies/fastqs/VB21001_R2.fastq.gz > VB21001

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

mapfile -t ROOTS < "$ROOT_FILE"
#Reads file from $ROOT_FILE and assigns to $ROOTS

R1="$SAMPLE_DIR""${ROOTS[$SLURM_ARRAY_TASK_ID]}""_R1.fastq.gz"
R2="$SAMPLE_DIR""${ROOTS[$SLURM_ARRAY_TASK_ID]}""_R2.fastq.gz"
#Sets variable for each read

mkdir -p $OUT
#Makes output directory if it doesn't already exist

OUT1="$OUT_DIR""${ROOTS[$SLURM_ARRAY_TASK_ID]}""_R1.trimmed.fastq.gz"
OUT2="$OUT_DIR""${ROOTS[$SLURM_ARRAY_TASK_ID]}""_R2.trimmed.fastq.gz"
#Sets output file names

NAME=${ROOTS[$SLURM_ARRAY_TASK_ID]}
#Gets the root from $ROOTS to use in report outputs

fastp --in1 $R1 --in2 $R2 \
	-2 -q 20 -l 50 \
	--out1 $OUT1 --out2 $OUT2 \
	-l 50 \
	-h "$OUTDIR""$NAME".html" \
	&> "$OUTDIR""$NAME".log"
#Runs fastp