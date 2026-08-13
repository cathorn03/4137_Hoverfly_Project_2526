#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=13_INV_filter
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0

usage(){
	#Help message for the script
	echo "Usage: sbatch [slurm-options] $0 [options]"
	echo
	echo "Options:"
	echo "	-v, --vcf     VCF file to filter"
	echo "  -o, --out     Output file"
	echo "  -h, --help    Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in

		-o|--out)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			OUT="$2" 
			shift 2 ;;
			#Sets -o to OUT. This should be the output VCF file.

		-v|--vcf)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			VCF="$2" 
			shift 2 ;;
			#Sets -v to VCF. This should be the output VCF file.

    -h|--help)
      usage
      exit 0
      ;;
      #Runs usage

    *) echo "Invalid option: $1" 
      exit 1 ;;
      #Error handling for incorrect options
  esac
done

bcftools view -i 'INFO/SVTYPE="INV"' $VCF -o $OUT #Runs BCFtools view. Filters VCF for inversions.