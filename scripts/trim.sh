#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=trim
#SBATCH --output=./logsOut/slurm-%x-%j.out
#SBATCH --error=./logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-42

source $HOME/.bash_profile
conda activate hoverflies

mkdir trimmed

mapfile -t ROOTS < roots.txt

R1=../fastqs/${ROOTS[$SLURM_ARRAY_TASK_ID]}"_R1.fastq.gz"
R2=../fastqs/${ROOTS[$SLURM_ARRAY_TASK_ID]}"_R2.fastq.gz"

OUT1=./trimmed/${ROOTS[$SLURM_ARRAY_TASK_ID]}_R1.trimmed.fastq.gz
OUT2=./trimmed/${ROOTS[$SLURM_ARRAY_TASK_ID]}_R2.trimmed.fastq.gz

OUTDIR=./trimmed/
NAME=${ROOTS[$SLURM_ARRAY_TASK_ID]}

fastp --in1 $R1 --in2 $R2 \
	--out1 $OUT1 --out2 $OUT2 \
	-l 50 \
	-h "$OUTDIR""$NAME".html" \
	&> "$OUTDIR""$NAME".log"
