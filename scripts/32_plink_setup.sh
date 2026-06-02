l#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=8g
#SBATCH --time=8:00:00
#SBATCH --job-name=32_Plink_setup
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

module load bcftools-uoneasy/1.19-GCC-13.2.0 

PATH_TO=/share/hoverflies/Caleb/haplotype_1

BCF_IN=$PATH_TO/VCF/VB_miss.vcf.gz
BCF_OUT=$PATH_TO/VCF/VB_snps.vcf.gz

bcftools view --threads 20 -m2 -M2 -v snps $BCF_IN -Oz -o $BCF_OUT
#Cleans VCF, Keeps only Biallelic and varient SNPS

bcftools index $BCF_OUT
#Indexes VCF

mkdir -p $PATH_TO/plink

cd $PATH_TO/plink

plink --threads 20 --vcf $BCF_OUT --double-id --allow-extra-chr --make-bed --out VB_raw
#Turns VCF into plink accepted binary file
#--allow-extra-chr allows non-human chr use
#--double-id uses Sample ID for both that and family ID

plink --threads 20 --bfile VB_raw --missing --allow-extra-chr --out VB_missing
#Checks missingness
