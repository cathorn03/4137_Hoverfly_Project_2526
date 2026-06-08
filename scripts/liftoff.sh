#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=liftoff
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb/references
REF_ROOT=idVolBomb13_plumata

REF_GZ=$PATH_TO/$REF_ROOT.fa.gz

gunzip $REF_GZ

REF=$PATH_TO/$REF_ROOT.fa
GFF=$PATH_TO/GCA_949129095.1_idVolBomb1.1_genomic.gff
OUT=$PATH_TO/$REF_ROOT.gff

liftoff -g $GFF \
	-o $OUT \
	-u unmapped.gff \
	-p 8
