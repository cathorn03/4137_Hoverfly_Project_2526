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
TARET_ROOT=idVolBomb13_plumata
REF_ROOT=GCA_949129095.1_idVolBomb1.1_genomic

TARGET=$PATH_TO/$TARGT_ROOT.fa
REF=$PATH_TO/$REF_ROOT.fasta
GFF=$PATH_TO/$REF_ROOT.gff
OUT=$PATH_TO/$TARGET_ROOT.gff

liftoff -g $GFF \
	-o $OUT \
	-u unmapped.gff \
	-p 8 \
	$TARGET \
	$REF
