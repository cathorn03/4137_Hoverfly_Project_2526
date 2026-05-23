#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1g
#SBATCH --time=4:00:00
#SBATCH --job-name=PCA_prep
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load plink-uoneasy/2.00a3.7-foss-2023a

PATH_TO=/share/hoverflies/Caleb

mkdir -p $PATH_TO/PCA
CD $PATH_TO/PCA

VCF=$PATH_TO/VCF/VB.70b.vcf.gz

plink --vcf $VCF --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.05 --out VB

plink --vcf $VCF --double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract stick.prune.in \
--make-bed --pca --out VB