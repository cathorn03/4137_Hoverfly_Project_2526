#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=VCF_merge
#SBATCH --output=./logsOut/slurm-%x-%j.out
#SBATCH --error=./logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

bcftools concat --file-list vcf_list.txt -Oz --output ./VCF/VB.vcf.gz
bcftools index ./VCF/VB.vcf.gz
