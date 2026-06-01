#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=8:00:00
#SBATCH --job-name=VCF_filter
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0
#loads BCFtools slurm module

PATH_TO=/share/hoverflies/Caleb

VCF_IN=$PATH_TO/haplotype_2/VCF/VB.vcf.gz
VCF_OUT=$PATH_TO/haplotype_2/VCF/VB.70.vcf.gz

MAF=0.05
MISS=0.7
QUAL=20
MIN_DEPTH=1
MAX_DEPTH=50

vcftools --gzvcf $VCF_IN \
	--remove-indels \
	--maf $MAF \
	--max-missing $MISS \
	--minQ $QUAL \
	--min-meanDP $MIN_DEPTH \
	--max-meanDP $MAX_DEPTH \
	--minDP $MIN_DEPTH \
	--maxDP $MAX_DEPTH \
	--recode \
	--stdout | bgzip -c > \
	$VCF_OUT

bcftools index $VCF_OUT

VCFB=$PATH_TO/haplotype_2/VCF/VCF.70b.vcf.gz

bcftools view -Oz --max-alleles 2 --exclude-types indels -o $VCFB $VCF_OUT
bcftools view -H $VCFB | wc -l > $VCFB.SNPS.txt
