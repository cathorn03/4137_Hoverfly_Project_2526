#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8g
#SBATCH --time=1:00:00
#SBATCH --job-name=08_VCF_Chrom_Select
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
# Activates conda env

module load bcftools-uoneasy/1.19-GCC-13.2.0

usage(){
  echo "Usage: sbatch [slurm-options] $0 [options]"
  echo
  echo "Options:"
  echo "  -v, --vcf				Input vcf file"
  echo "  -c, --chr_file		Comma seperated file with the names of the wanted chromosomes"
  echo "  -o, --out				Output file"
  echo "  -h, --help			Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in

    -v|--vcf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCF="$2" 
      shift 2 ;;

    -c|--chr_file)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      $CHR_FILE="$2"
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

mapfile -t CHRS < $CHR_FILE

bcftools view $VCF --regions $CHRS > $OUT