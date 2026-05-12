#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=high_GC
#SBATCH --output=./logsOut/slurm-%x-%j.out
#SBATCH --error=./logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda actovate hoverflies
#Activates conda env

PATH_TO=/share/hoverflies/
#Makes directory path

mkdir -p $PATH_TO/Caleb/high_GC
#Creates output directory

seqkit seq -g -m 65 $PATH_TO/fastqs/VB21036_R1.fastq.gz > $PATH_TO/Caleb/high_GC/VB21036_R1.fastq.gz
seqkit seq -g -m 65 $PATH_TO/fastqs/VB21036_R2.fastq.gz > $PATH_TO/Caleb/high_GC/VB21036_R2.fastq.gz
#Runs seqkit on sample identifed with high GC reads
#Filters for samples with GC > 65 (-m 65)