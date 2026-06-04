#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=48:00:00
#SBATCH --job-name=06_VCF
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

module load bcftools-uoneasy/1.19-GCC-13.2.0
#Loads slurm modules

PATH_TO=/share/hoverflies/Caleb
#Sets directory path

mkdir -p $PATH_TO/haplotype_2/VCF
#Creates output directory

REF=$PATH_TO/references/GCA_949129105.1_idVolBomb1.1_alternate_haplotype_genomic.fna
OUT=$PATH_TO/haplotype_2/VCF/VB.vcf.gz
#Sets reference and output directory

BAMS=$PATH_TO/bam_list.txt
#Assigns bam_list.txt to a variable
#bam_list.txt contains the full path for each bam file

bcftools mpileup \
  --threads 20 \
  -Ou \
  -f "$REF" \
  --min-MQ 20 \
  --min-BQ 30 \
  --platforms ILLUMINA \
  --annotate FORMAT/DP,FORMAT/AD \
  --bam-list "$BAMS" | \
bcftools call \
  --threads 20 \
  -m \
  -v \
  -a GQ,GP \
  -Oz \
  -o "$OUT"
#Generates VCF files

bcftools index $OUT
#Indexes VCF
