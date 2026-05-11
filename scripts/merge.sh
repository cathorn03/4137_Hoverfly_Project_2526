#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=merge
#SBATCH --output=./logsOut/slurm-%x-%j.out
#SBATCH --error=./logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-42

PATH_TO=/share/hoverflies/Caleb

mapfile -t ROOTS < $PATH_TO/roots.txt

mkdir merged_fq

MERGE=/share/hoverflies/fastqs/${ROOTS[$SLURM_ARRAY_TASK_ID]}*.fastq.gz
OUT=$PATH_TO/merged_fq/${ROOTS[$SLURM_ARRAY_TASK_ID]}.fastq.gz

cat $MERGE > $OUT
