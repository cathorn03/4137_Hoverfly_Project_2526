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

source $HOME/.bash_profile
conda actovate list

LIST=/share/hoverflies/Caleb/vcf_list.txt
OUT=/share/hoverflies/Caleb/VCF/VB.vcf.gz

bcftools concat --file-list $LIST -Oz --output $OUT
bcftools index $OUT
