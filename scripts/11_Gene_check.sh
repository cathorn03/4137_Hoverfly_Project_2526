#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=128g
#SBATCH --time=8:00:00
#SBATCH --job-name=11_Gene_Check
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

module load bedtools-uoneasy/2.31.0-GCC-12.3.0
#loads BEDtools slurm module

usage(){
  echo "Usage: sbatch [slurm-options] $0 [options]"
  echo
  echo "Options:"
  echo "  -b, --bed   Input vcf file"
  echo "  -g, --gff   Annotation file in a gff format"
  echo "  -o, --out   Output file"
  echo "  -h, --help  Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in

    -b|--bed)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      BED="$2" 
      shift 2 ;;
      #Sets -b to BED. This should be the BED file containing the regions to look for the overlap

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT="$2" 
      shift 2 ;;
      #Sets -o to out. This is the output file and path

    -g|--gff)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      GFF="$2"
      shift 2 ;;
      #Sets -g to GFF. This is the GFF file to search for annotations within the coordinates in the BED file

    -h|--help)
      usage
      exit 0
      ;;

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done


bedtools intersect \
-a $GFF \
-b $BED \
-u | awk '$3 == "gene"' > $OUT


