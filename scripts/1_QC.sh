#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=fastqc
#SBATCH --output=./logsOut/slurm-%x-%j.out
#SBATCH --error=./logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-86

# Importing Conda Environment
source $HOME/.bash_profile
conda activate hoverflies

mapfile -t NAMES < /share/hoverflies/Caleb/names.txt

mkdir ./QC

SAMPLE="/share/hoverflies/fastqs/"${NAMES[$SLURM_ARRAY_TASK_ID]} #Makes smaple name for arrays
OUTDIR=/share/hoverflies/Caleb/QC #Sets output

# Running QC Analysis
fastqc \
 -t 8 \
 "$SAMPLE" \
 -o "$OUTDIR"
#Runs fastqc
