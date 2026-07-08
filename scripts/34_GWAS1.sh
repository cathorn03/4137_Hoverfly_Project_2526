#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32g
#SBATCH --time=8:00:00
#SBATCH --job-name=34_GWAS1
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

module load plink-uoneasy/1.9b_6.21-x86_64

PATH_TO=/share/hoverflies/Caleb
HAPLOTYPE=haplotype_1

cd $PATH_TO/$HAPLOTYPE/plink

PHENO=$PATH_TO/pheno_plink.txt

plink --threads 16 \
        --bfile VB_qc \
        --allow-extra-chr \
        --allow-no-sex \
        --pheno $PHENO \
        --logistic \
        --out GWAS_chr6
