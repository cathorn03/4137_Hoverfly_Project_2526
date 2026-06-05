#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=21_PCA
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0

PATH_TO=/share/hoverflies/Caleb/haplotype_1

mkdir -p $PATH_TO/PCA
cd $PATH_TO/PCA

IN=$PATH_TO/VCF/VB.70b.vcf.gz
OUT=$PATH_TO/VCF/VB_chr6.vcf.gz

test=/share/hoverflies/Caleb/PCA_test.txt

bcftools view --threads 20 -r OX422145.1:10990001-11041001 -O z -o $OUT $IN

bcftools index -s $IN | grep OX422145.1 > $test

#VCF=$PATH_TO/VCF/VB_chr6.vcf.gz

#plink --vcf "$VCF" --double-id --allow-extra-chr \
#--set-missing-var-ids @:# \
#--indep-pairwise 50 10 0.05 --out VB

#plink --vcf "$VCF" --double-id --allow-extra-chr --set-missing-var-ids @:# \
#--extract VB.prune.in \
#--make-bed --pca --out VB