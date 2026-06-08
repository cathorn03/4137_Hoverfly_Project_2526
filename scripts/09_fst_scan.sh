#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=09_FST_scan
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-6

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb
HAPLOTYPE=haplotype_2

mkdir -p $PATH_TO/$HAPLOTYPE/FST

cd $PATH_TO/$HAPLOTYPE/FST

VCF=$PATH_TO/$HAPLOTYPE/VCF/VCF.70b,vcf.gz
POP1=$PATH_TO/bombylans.txt
POP2=$PATH_TO/plumata.txt

mapfile -t FST_WINDOWS < $PATH_TO/fst_windows.txt

WINDOW=${FST_WINDOWS[$SLURM_ARRAY_TASK_ID]} 

vcftools --gzvcf $VCF \
--max-missing 0.7 \
--maf 0.05 \
--weir-fst-pop $POP1 \
--weir-fst-pop $POP2 \
--fst-window-size $WINDOW \
--fst-window-step $WINDOW \
--out $WINDOW


