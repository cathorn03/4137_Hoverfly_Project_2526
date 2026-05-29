#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8g
#SBATCH --time=4:00:00
#SBATCH --job-name=Helixer
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate Helixer

PATH_TO=/share/hoverflies/Caleb

Helixer=$PATH_TO/Helixer/Helixer.py
FASTA=$PATH_TO/references/GCA_949129095.1_idVolBomb1.1_genomic.fasta
OUT=$PATH_TO/references/helixer_VolBomb1.1.gff3

python $Helixer \
	--lineage invertebrate \
	--fasta-path $FASTA \
	--species Volucella_bombylans \
	--gff-output-path $OUT