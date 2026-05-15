#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=FST_scan
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

$PATH_TO=/share/hoverflies/Caleb

mkdir -p $PATH_TO/FST

cd $PATH_TO/FST

VCF=$PATH_TO/VCF/VB.70.vcf.gz
POP1=$PATH_TO/bombylans.txt
POP2=$PATH_TO/plumata.txt

vcftools --gzvcf $VCF \
--max-missing 0.8 \
--maf 0.05 \
--weir-fst-pop $POP1 \
--weir-fst-pop $POP2 \
--fst-window-size 5000 \
--fst-window-step 5000
