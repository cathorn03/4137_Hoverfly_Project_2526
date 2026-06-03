#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=4:00:00
#SBATCH --job-name=scaffolding
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb

mkdir -p $PATH_TO/ragtag

REF=$PATH_TO/references/GCA_949129095.1_idVolBomb1.1_genomic.fasta
TARGET=$PATH_TO/references/GCA_949129105.1_idVolBomb1.1_alternate_haplotype_genomic.fasta
OUT=$PATH_TO/ragtag

ragtag.py scaffold -o $OUT $REF $TARGET
