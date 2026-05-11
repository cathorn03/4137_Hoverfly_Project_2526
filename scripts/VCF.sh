#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=VCF
#SBATCH --output=./logsOut/slurm-%x-%j.out
#SBATCH --error=./logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb

mkdir -p VCF

mapfile -t CHRS < $PATH_TO/chr_names.txt

CHROM=${CHRS[$SLURM_ARRAY_TASK_ID]}

REF=$PATH_TO/references/GCA_949129095.1_idVolBomb1.1_genomic.fna
OUT=$PATH_TO/VCF/VB.$CHROM.vcf.gz

BAMS=$PATH_TO/bam_list.txt

bcftools mpileup \
  --threads 20 \
  -Ou \
  -f "$REF" \
  --min-MQ 20 \
  --min-BQ 30 \
  --platforms ILLUMINA \
  --annotate FORMAT/DP,FORMAT/AD \
  --bam-list "$BAMLIST" \
  -r "$CHROM" | \
bcftools call \
  --threads 20 \
  -m \
  -v \
  -a GQ,GP \
  -Oz \
  -o "$OUT"

bcftools index $OUT

