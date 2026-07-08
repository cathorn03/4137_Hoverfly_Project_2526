#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=35_Population_correction
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

cd /share/hoverflies/Caleb/haplotype_1/plink

plink --threads 16 --bfile VB_qc --allow-extra-chr --indep-pairwise 50 5 0.2 --out prune

plink --threads 16 --bfile VB_qc --allow-extra-chr --extract prune.prune.in --pca 20 --out pca20