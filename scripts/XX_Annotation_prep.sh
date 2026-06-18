#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64g
#SBATCH --time=1:00:00
#SBATCH --job-name=VCF_Scan
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0

bcftools query -f '%QUAL\n' /share/hoverflies/Caleb/haplotype_1/VCF/VB.vcf.gz \
	> /share/hoverflies/Caleb/haplotype_1/VCF/qual.txt
