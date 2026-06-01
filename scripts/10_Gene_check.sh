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

ANOT=$PATH_TO/references/GCA_949129095.1_idVolBomb1.1_genomic.gff
GENES_BED=$PATH_TO/haplotype_1/genes/genes.bed

sortBed -i $ANOT | gff2bed > $GENES_BED

FST_BED=$PATH_TO/haplotype_1/genes/high_fst.bed
OUT=$PATH_TO/haplotype_1/genes/genes_in_windows.txt

bedtools intersect \
-a $FST_BED \
-b $GENES_BED \
-wo > $OUT
