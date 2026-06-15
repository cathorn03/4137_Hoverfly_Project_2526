#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=02_multiqc
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

usage(){
	#Help message for the script
	echo "Usage: sbatch $0 [options]"
	echo
	echo "Options:"
	echo "  -q, --fastq		Input FASTQ directory"
	echo "  -o, --out			Output directory"
	echo "  -h, --help		Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
  	-q|--fastq)
	  	[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
	  	QC="$2"
	  	shift 2 ;;
	  	# Sets -q to $SAMPLE_DIR. Should be a directory for the fastq files

		-o|--out)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			OUT="$2" 
			shift 2 ;;
			# Sets -o to $OUT. Should be the output directory

		-h|--help)
			usage
			exit 0
			;;
			# Runs usage

		*) echo "Invalid option: $1" 
			exit 1 ;;
  esac
done

cd $QC #Enters QC directory

mkdir -p $OUT #Makes output directory if it doesn't already exists

multiqc $OUT
#Runs multiqc, and outputs to $OUT

