#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=48:00:00
#SBATCH --job-name=VCF
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-5

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

module load bcftools-uoneasy/1.19-GCC-13.2.0
#Loads slurm modules

PATH_TO=/share/hoverflies/Caleb
#Sets directory path

mkdir -p $PATH_TO/VCF
#Creates output directory

mapfile -t CHRS < $PATH_TO/chr_list.txt
#Reads chr_list.txt and assigns to $CHRS
#chr_list.txt contains chromosome names for VB

CHROM=${CHRS[$SLURM_ARRAY_TASK_ID]}
#Assigns chromosome

REF=$PATH_TO/references/GCA_949129095.1_idVolBomb1.1_genomic.fasta
OUT=$PATH_TO/VCF/VB.$CHROM.vcf.gz
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
  --bam-list "$BAMS" \
  -r "$CHROM" | \
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
