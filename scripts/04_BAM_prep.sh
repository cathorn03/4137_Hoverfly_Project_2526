#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8g
#SBATCH --time=1:00:00
#SBATCH --job-name=04_BAM_prep
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
# Activates conda env

usage(){
	echo "Usage: $0 [options][refrence]"
	echo
	echo "Options:"
	echo "  -h, --help    Show this help message"
	echo "  [reference]   The refrence file needing to be indexed"
}

POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case "$1" in

	-h|--help)
		usage
		exit 0
		;;

    *)
        if [[ "$1" == -* ]]; then
            echo "Invalid option: $1"
            exit 1
        fi

        POSITIONAL+=("$1")
        shift
        ;;
	esac
done

if [[ ${#POSITIONAL[@]} -ne 1 ]]; then
    echo "Error: expected one reference filename"
    exit 1
fi

REF="${POSITIONAL[0]}"

bwa index $REF # Indexes reference genome
#Indexes reference genome
