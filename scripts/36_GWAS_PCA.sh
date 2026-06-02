#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=36_GWAS_PCA
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load plink-uoneasy/1.9b_6.21-x86_64

cd /share/hoverflies/Caleb/haplotype_1/plink
PHENO=/share/hoverflies/Caleb/pheno_plink.txt

plink --threads 16 \
        --bfile VB_qc \
        --allow-extra-chr \
        --allow-no-sex \
        --pheno $PHENO \
        --covar pca20.eigenvec \
        --covar-number 1-3 \
        --logistic \
        --out GWAS_PCA3