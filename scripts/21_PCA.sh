#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8g
#SBATCH --time=4:00:00
#SBATCH --job-name=PCA
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb

mkdir -p $PATH_TO/PCA
cd $PATH_TO/PCA

VCF=$PATH_TO/VCF/VB.70b.vcf.gz
plink --vcf "$VCF" --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.05 --out VB

plink --vcf "$VCF" --double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract VB.prune.in \
--make-bed --pca --out VB