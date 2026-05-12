#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8g
#SBATCH --time=1:00:00
#SBATCH --job-name=high_GC
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

PATH_TO=/share/hoverflies/
#Makes directory path

mkdir -p $PATH_TO/Caleb/high_GC
#Creates output directory

seqkit fx2tab -g $PATH_TO/fastqs/VB21036_R1.fastq.gz | \
awk '$2 >= 65 && $2 <= 80' | \
seqkit tab2fx > $PATH_TO/Caleb/high_GC/VB21036_R1.fastq

seqkit fx2tab -g $PATH_TO/fastqs/VB21036_R2.fastq.gz | \
awk '$2 >= 65 && $2 <= 80' | \
seqkit tab2fx > $PATH_TO/Caleb/high_GC/VB21036_R2.fastq
#Runs seqkit on sample identifed with high GC reads. Outputs in unzipped format
#Filters for samples with GC > 0.65