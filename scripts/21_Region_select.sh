#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=21_Region_select
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0

usage(){
  echo "Usage: $0 [options]"
  echo
  echo "Options:"
  echo "  -v, --vcf         Input vcf file"
  echo "  -r, --region      Selected region to filter"
  echo "  -o, --out         Output vcf file"
  echo "  -h, --help        Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--vcf)
      [[ -z "$2" ]] && { echo "Missing argument for $1"; exit 1; }
      VCF="$2"
      shift 2 ;;

    -r|--region)
      [[ -z "$2" ]] && { echo "Missing argument for $1"; exit 1; }
      REGION="$2"
      shift 2 ;;

    -o|--out)
      [[ -z "$2" ]] && { echo "Missing argument for $1"; exit 1; }
      OUT="$2" 
      shift 2 ;;

     -p|--prefix)
      [[ -z "$2" ]] && { echo "Missing argument for $1"; exit 1; }
      PRE="$2" 
      shift 2 ;;

    -h|--help)
      usage
      exit 0
      ;;

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done

bcftools view --threads 20 -r $REGION -O z -o $OUT $VCF

