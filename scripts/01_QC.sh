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

PATH_TO=/share/hoverflies/Caleb
#Sests working path

mapfile -t NAMES < $PATH_TO/names.txt
#Reads names.txt and assigns to $NAME
#names.txt contains the names of all fastq files in /share/hoverflies/fastqs/

mkdir -p $PATH_TO/QC
#Makes output dir

SAMPLE=$PATH_TO${NAMES[$SLURM_ARRAY_TASK_ID]} #Makes smaple name for arrays
OUTDIR=$PATH_TO/QC #Sets output

# Running QC Analysis
fastqc \
 -t 8 \
 "$SAMPLE" \
 -o "$OUTDIR"
#Runs fastqc
