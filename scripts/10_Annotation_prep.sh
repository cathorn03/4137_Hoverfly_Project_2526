#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16g
#SBATCH --time=8:00:00
#SBATCH --job-name=Annotation_prep
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate genometools

PATH_TO=/share/hoverflies/Caleb/references

gunzip $PATH_TO/GCA_949129095.1_idVolBomb1.1_genomic.gbff.gz

gt genbank_to_gff3 -o $PATH_TO/genome.gff3 $PATH_TO/GCA_949129095.1_idVolBomb1.1_genomic.gbff