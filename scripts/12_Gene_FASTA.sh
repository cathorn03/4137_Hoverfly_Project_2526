#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16g
#SBATCH --time=8:00:00
#SBATCH --job-name=Gene_FASTA
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb

ANNOTATION=$PATH_TO/references/helixer_VolBomb1.1.gff3
REF=$PATH_TO/references/GCA_949129095.1_idVolBomb1.1_genomic.fasta
OUT=$PATH_TO/genes/high_fst_seqs.fasta

gffread -g $REF -w $OUT $ANNOTATION
