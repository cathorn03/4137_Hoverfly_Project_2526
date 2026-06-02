#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8g
#SBATCH --time=1:00:00
#SBATCH --job-name=04_BAM_prep
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
# Activates conda env

#gunzip /share/hoverflies/Caleb/references/GCA_949129105.1_idVolBomb1.1_alternate_haplotype_genomic.fna.gz # Unzips reference genome
#Unzips reference genome

bwa index /share/hoverflies/Caleb/references/GCA_949129105.1_idVolBomb1.1_alternate_haplotype_genomic.fna # Indexes reference genome
#Indexes reference genome
