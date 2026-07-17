#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=12_delly
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

usage(){
	#Help message for the script
	echo "Usage: sbatch [slurm-options] $0 [options]"
	echo
	echo "slurm-options:"
	echo "  --array=			Array range for the number of samples"
	echo
	echo "Options:"
	echo "  -f, --reference		Input FASTQ directory"
	echo "  -o, --out			Output directory"
	echo "  -n, --names		A .txt file containg the names of the fastq files"
	echo "  -h, --help		Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
		-f|--reference)
	  		[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
	  		REF="$2"
	  		shift 2 ;;

		-b|--BAM)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			BAM="$2" 
			shift 2 ;;

		-o|--out)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			OUT="$2" 
			shift 2 ;;

		-h|--help)
			usage
			exit 0
			;;

		*) echo "Invalid option: $1" 
			exit 1 ;;
  esac
done


delly sr -g $REF $BAM > $OUT

bcftools index $VCF
#Indexes VCF