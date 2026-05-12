#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=trim
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-42

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies

mkdir trimmed

mapfile -t ROOTS < $PATH_TO/Caleb/roots.txt

R1=$PATH_TO/fastqs/${ROOTS[$SLURM_ARRAY_TASK_ID]}"_R1.fastq.gz"
R2=$PATH_TO/fastqs/${ROOTS[$SLURM_ARRAY_TASK_ID]}"_R2.fastq.gz"

OUT1=$PATH_TO/Caleb/trimmed/${ROOTS[$SLURM_ARRAY_TASK_ID]}_R1.trimmed.fastq.gz
OUT2=$PATH_TO/Caleb/trimmed/${ROOTS[$SLURM_ARRAY_TASK_ID]}_R2.trimmed.fastq.gz

OUTDIR=$PATH_TO/Caleb/trimmed/
NAME=${ROOTS[$SLURM_ARRAY_TASK_ID]}

fastp --in1 $R1 --in2 $R2 \
	--out1 $OUT1 --out2 $OUT2 \
	-l 50 \
	-h "$OUTDIR""$NAME".html" \
	&> "$OUTDIR""$NAME".log"
