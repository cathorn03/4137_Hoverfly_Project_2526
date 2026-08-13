#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=48:00:00
#SBATCH --job-name=07_VCF_Chrom_Select
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
# Activates conda env

module load bcftools-uoneasy/1.19-GCC-13.2.0
#Loads module for script

usage(){
  #Help message for the script
  echo "Usage: sbatch [slurm-options] $0 [options]"
  echo
  echo "Options:"
  echo "  -v, --vcf         Input vcf file"
  echo "  -c, --chr_file    Comma seperated file with the names of the wanted chromosomes"
  echo "  -o, --out         Output file"
  echo "  -h, --help        Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in

    -v|--vcf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCF="$2" 
      shift 2 ;;
      #Sets -v to VCF. THis should be the input VCF file

    -c|--chr_file)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      CHR_FILE="$2"
      shift 2 ;;
      #Sets -c to CHR_FILE. This should be the file containing the comma separated list of chromsome names as in the VCF file

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT="$2" 
      shift 2 ;;
      #Sets -o to out. This is the output file and path

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

CHRS=$(<"$CHR_FILE")

bcftools view --threads 20 --regions "$CHRS" -Oz -o "$OUT" "$VCF" 
#Runs bcftools view with 20 threads. Regions selected are the chromsomes listed in CHRS