#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=8g
#SBATCH --time=2:00:00
#SBATCH --job-name=BCF_view
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0

IN=/share/hoverflies/Caleb/VCF/VB.vcf.gz
OUT=/share/hoverflies/Caleb/VCF/VB_miss.vcf.gz

bcftools view -i 'F_MISSING < 0.1' -O z -o $OUT $IN
