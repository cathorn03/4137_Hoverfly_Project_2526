#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8g
#SBATCH --time=1:00:00
#SBATCH --job-name=BAM_prep
#SBATCH --output=./logsOut/slurm-%x-%j.out
#SBATCH --error=./logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

# Activates conda env
source $HOME/bash_profile
conda activate hoverflies

gunzip ./references/GCA_949129095.1_idVolBomb1.1_genomic.fna.gz # Unzips reference genome

bwa index ./references/GCA_949129095.1_idVolBomb1.1_genomic.fna # Indexes reference genome
