#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16g
#SBATCH --time=2:00:00
#SBATCH --job-name=GWAS1
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

module load plink-uoneasy/1.9b_6.21-x86_64

PATH_TO=/share/hoverflies/Caleb

cd $PATH_TO/plink

PHENO=$PATH_TO/pheno_plink.txt

plink --bfile VB_qc \
        --allow-extra-chr \
        --allow-no-sex \
        --pheno $PHENO \
        --logistic \
        --out GWAS1
