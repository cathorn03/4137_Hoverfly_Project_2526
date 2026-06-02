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

PATH_TO=/share/hoverflies
#Sets path

mapfile -t ROOTS < $PATH_TO/Caleb/roots.txt
#Reads roots.txt and assigns to $ROOTS
#roots.txt contains sample names for samples in /share/hoverflies/fastqs/ without read direction and file extension
#e.g. /share/hoverflies/fastqs/VB21001_R2.fastq.gz > VB21001

R1=$PATH_TO/fastqs/${ROOTS[$SLURM_ARRAY_TASK_ID]}"_R1.fastq.gz"
R2=$PATH_TO/fastqs/${ROOTS[$SLURM_ARRAY_TASK_ID]}"_R2.fastq.gz"
#Sets names for each read

mkdir -p $PATH_TO/Caleb/trimmed
#Makes output directory

OUT1=$PATH_TO/Caleb/trimmed/${ROOTS[$SLURM_ARRAY_TASK_ID]}_R1.trimmed.fastq.gz
OUT2=$PATH_TO/Caleb/trimmed/${ROOTS[$SLURM_ARRAY_TASK_ID]}_R2.trimmed.fastq.gz
#Sets output file names

OUTDIR=$PATH_TO/Caleb/trimmed/
#Sets output directory

NAME=${ROOTS[$SLURM_ARRAY_TASK_ID]}
#Sets output file names

fastp --in1 $R1 --in2 $R2 \
	--out1 $OUT1 --out2 $OUT2 \
	-l 50 \
	-h "$OUTDIR""$NAME".html" \
	&> "$OUTDIR""$NAME".log"
#Runs fastp