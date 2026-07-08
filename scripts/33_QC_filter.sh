#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=8g
#SBATCH --time=2:00:00
#SBATCH --job-name=33_QC_filter
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

cd /share/hoverflies/Caleb/haplotype_1/plink

plink --bfile VB_raw --allow-extra-chr \
	--geno 0.05 \
	--mind 0.05 \
	--maf 0.001 \
	--make-bed \
	--out VB_qc
