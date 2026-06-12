#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=NN_VCF
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0
#loads BCFtools slurm module

usage(){
  echo "Usage: sbatch $0 [options]"
  echo
  echo "Options:"
  echo "  -v, --vcf       		Input VCF file"
  echo "  -so, --stats-out      Output file for the VCF stats"
  echo "  -vo, --view-out		Output for bcftools view"
  echo "  -h, --help			Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--vcf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      SAMPLE_DIR="$2"
      shift 2 ;;

    -so|--stats-out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT_DIR="$2" 
      shift 2 ;;

    -vo|--view-out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MAF="$2" 
      shift 2 ;;

    -h|--help)
      usage
      exit 0
      ;;

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done

bcftools stats input.vcf.gz > stats.txt