#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=20g
#SBATCH --time=8:00:00
#SBATCH --job-name=07_VCF_merge
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

module load bcftools-uoneasy/1.19-GCC-13.2.0
#loads BCFtools slurm module

LIST=/share/hoverflies/Caleb/vcf_list.txt
#Sets VCF file list
#vcf_list.txt contains the list of all VCF files

OUT=/share/hoverflies/Caleb/haplotype_1/VCF/VB.vcf.gz
#Sets output file

bcftools concat --file-list $LIST -Oz --output $OUT
#Concatinates all VCF files
bcftools -f index $OUT
#Indexes output
