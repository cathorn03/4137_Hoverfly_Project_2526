#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=8:00:00
#SBATCH --job-name=Gene_Check
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bedtools-uoneasy/2.31.0-GCC-12.3.0
#loads bedtools slurm module

PATH_TO=/share/hoverflies/Caleb

mkdir -p $PATH_TO/genes

ANNOT=$PATH_TO/references/GCA_949129095.1_idVolBomb1.1_genomic.gbff.gz
BED=
OUT=

bedtools intersect \
-a $ANNOT \
-b highfst.bed \
-wa > candidate_genes.gff3