#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8g
#SBATCH --time=1:00:00
#SBATCH --job-name=BAM_prep
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-1

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/

mapfile -t NAMES < $PATH_TO/Caleb/high_gc_list.txt

SAMPLE=$PATH_TO/fastqs/${NAMES[$SLURM_ARRAY_TASK_ID]}

OUT_NAME=$(basename ${NAMES[$SLURM_ARRAY_TASK_ID]} .fastq).filtered.fastq

OUT=$PATH_TO/Caleb/high_gc/$OUT_NAME

printf "%s" "$SAMPLE" | gc_filter.py > $OUT