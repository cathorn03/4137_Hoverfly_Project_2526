#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=16g
#SBATCH --time=2:00:00
#SBATCH --job-name=31_BCF_view
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0

PATH_TO=/share/hoverflies/Caleb/haplotype_1

IN=$PATH_TO/VCF/VB.vcf.gz
OUT=$PATH_TO/VCF/VB_miss.vcf.gz

bcftools view --threads 20 -i 'F_MISSING < 0.1' -O z -o $OUT $IN
