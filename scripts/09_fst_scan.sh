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

source $HOME/.bash_profile
conda activate hoverflies

usage(){
  echo "Usage: sbatch $0 [options]"
  echo
  echo "Options:"
  echo "  -v, --vcf               Input vcf file"
  echo "  -w, --window            Size of sliding window for scan"
  echo "  -s, --step-size         Step size for the window to take"
  echo "  -p1, --population1      A file containg the full paths of the BAM files for the samples in a specific population"
  echo "  -p2, --population2      A file containg the full paths of the BAM files for the samples in a specific population"
  echo "  -o, --out               Output directory"
  echo "  -p, --prefix            Prefix for the output file name"
  echo "  -h, --help              Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--vcf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCF="$2"
      shift 2 ;;
      #Sets -v to $VCF. Should be the input VCF file

    -w|--windows)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      WINDOW="$2"
      shift 2 ;;
      #Sets -w to $WINDOWS_FILE. Should be the size wanted for the window of the FST scan. Should not contain commas or units

    -s|--step-size)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      STEP="$2"
      shift 2 ;;
      #Sets -s to STEP. This is the step size for the windo in the FST scan
      
    -p1|--population1)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      POP1="$2"
      shift 2 ;;
      #Sets -p1 to POP1. This is the file containing the individual IDs for population 1

    -p2|--population2)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      POP2="$2"
      shift 2 ;;
      #Sets -p2 to POP2. This is the file containing the individual IDs for population 1

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT_DIR="$2" 
      shift 2 ;;
      #Sets -o to $OUT_DIR. Should be the output directory

    -p|--prefix)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      PREFIX="$2" 
      shift 2 ;;
      #Stes -p to PREFIX. This is the prefix you want for the output files

    -h|--help)
      usage
      exit 0
      ;;
      #Runs usage

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done

mkdir -p $OUT_DIR

cd $OUT_DIR

vcftools --gzvcf $VCF \
--weir-fst-pop $POP1 \
--weir-fst-pop $POP2 \
--fst-window-size $WINDOW \
--fst-window-step $STEP \
--out $PREFIX

#Runs FST scan on VCF
#Uses POP1 and POP2 as the populations with a sliding window which is WINDOW in size and moves in step sizes of STEP. Output files have the prefix PREFIX

