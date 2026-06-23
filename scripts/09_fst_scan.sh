#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=09_FST_scan
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-6

source $HOME/.bash_profile
conda activate hoverflies

usage(){
  echo "Usage: sbatch [slurm-options] $0 [options]"
  echo
  echo "slurm-options:"
  echo "  --array=                Input array range for the number of windows to be tested"
  echo
  echo "Options:"
  echo "  -v, --vcf               Input vcf file"
  echo "  -w, --windows           A .txt file with window sizes wanting to be tested"
  echo "  -o, --out               Output directory"
  echo "  -h, --help              Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--vcf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCF="$2"
      shift 2 ;;
      # Sets -v to $VCF. Should be the VCF file

    -w|--windows)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      WINDOWS_FILE="$2"
      shift 2 ;;
      # Sets -w to $WINDOWS_FILE. Should be a .txt file containing the window sizes wanting to be used on different lines. 

    -p1|--population1)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      POP1="$2"
      shift 2 ;;

    -p2|--population2)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      POP2="$2"
      shift 2 ;;

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT_DIR="$2" 
      shift 2 ;;

    -h|--help)
      usage
      exit 0
      ;;

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done

mkdir -p $OUT_DIR

cd $OUT_DIR

mapfile -t FST_WINDOWS < $WINDOWS_FILE

WINDOW=${FST_WINDOWS[$SLURM_ARRAY_TASK_ID]} 

vcftools --gzvcf $VCF \
--weir-fst-pop $POP1 \
--weir-fst-pop $POP2 \
--fst-window-size $WINDOW \
--fst-window-step $WINDOW \
--out $OUT_DIR


