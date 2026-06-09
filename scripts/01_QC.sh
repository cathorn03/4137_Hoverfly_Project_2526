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

while [[ $# -gt 0 ]]; do
  case $1 in
  	-q|--fastq) SAMPLE_DIR="$OPTARG" ;;
	-o|--out) OUT="$OPTARG" ;;
	-n|--names) $NAME_FILE="$OPTARG" ;;
	\?) echo "Invalid option: -$OPTARG" ;;
	:) echo "Option -$OPTARG requires an argument" ;;
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
