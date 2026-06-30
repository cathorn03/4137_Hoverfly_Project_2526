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

PATH_TO=/share/hoverflies

mapfile -t NAMES < $PATH_TO/Caleb/high_gc_list.txt

SAMPLE_NAME=${NAMES[$SLURM_ARRAY_TASK_ID]}

SAMPLE_gz=$PATH_TO/fastqs/$SAMPLE_NAME

SAMPLE_ROOT=$(basename $SAMPLE_NAME .fastq.gz)
OUT_NAME=${SAMPLE_ROOT}".filtered.fasta"

gunzip -c $SAMPLE_gz > $PATH_TO/Caleb/high_GC/$SAMPLE_ROOT".fastq"

SAMPLE=$PATH_TO/Caleb/high_GC/$SAMPLE_ROOT".fastq"

echo "$SAMPLE_NAME filtered by GC"

OUT=$PATH_TO/Caleb/high_GC/$OUT_NAME

SCRIPT=/gpfs01/home/mbyct9/GIT/4137_Hoverfly_Project_2526/scripts/gc_filter.py

printf "%s" "$SAMPLE" | python $SCRIPT > $OUT
