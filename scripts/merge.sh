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
#Sets path to driectory

mapfile -t ROOTS < $PATH_TO/roots.txt
#Reads roots.txt and assigns to $ROOTS
#roots.txt contains sample names for samples in /share/hoverflies/fastqs/ without read direction and file extension
#e.g. /share/hoverflies/fastqs/VB21001_R2.fastq.gz > VB21001

mkdir -p $PATH_TO/merged_fq
#Makes output directory

MERGE=/share/hoverflies/fastqs/${ROOTS[$SLURM_ARRAY_TASK_ID]}*.fastq.gz
#Gets files to merge

OUT=$PATH_TO/merged_fq/${ROOTS[$SLURM_ARRAY_TASK_ID]}.fastq.gz
#Sets output file name

cat $MERGE > $OUT
#Merges files
