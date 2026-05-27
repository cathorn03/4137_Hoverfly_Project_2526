#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8g
#SBATCH --time=4:00:00
#SBATCH --job-name=Get_FASTA
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb

REF=$PATH_TO/references/GCA_949129095.1_idVolBomb1.1_genomic.fasta
BED=$PATH_TO/genes/high_fst.bed
OUT=$PATH_TO/genes/candidate_genes.fasta

bedtools getfasta -name -fi $REF -bed $BED > $OUT
