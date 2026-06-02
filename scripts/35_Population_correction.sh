#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1g
#SBATCH --time=4:00:00
#SBATCH --job-name=35_Population_correction
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb/

cd $PATH_TO/plink

plink --bfile VB_qc --allow-extra-chr --indep-pairwise 50 5 0.2 --out prune

plink --bfile VB_qc --allow-extra-chr --extract prune.prune.in --pca 20 --out pca20