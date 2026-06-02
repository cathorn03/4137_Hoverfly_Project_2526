#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1g
#SBATCH --time=4mv:00:00
#SBATCH --job-name=36_GWAS_PCA
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb/

module load plink-uoneasy/1.9b_6.21-x86_64

cd filtered

plink --bfile VB_qc \
        --allow-extra-chr \
        --allow-no-sex \
        --pheno pheno.txt \
        --covar pca20.eigenvec \
        --covar-number 1-3 \
        --logistic \
        --out GWAS_PCA3