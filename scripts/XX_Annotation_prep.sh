#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64g
#SBATCH --time=1:00:00
#SBATCH --job-name=Annotation_prep
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

PATH_TO=/share/hoverflies/Caleb/references

OUT=$PATH_TO/VolBomb1.1.gff3
SCRIPT=/share/hoverflies/Caleb/4137_Hoverfly_Project_2526/scripts/gbff_convert.py

gunzip -c $PATH_TO/GCA_949129095.1_idVolBomb1.1_genomic.gbff.gz | \
python $SCRIPT > $OUT
