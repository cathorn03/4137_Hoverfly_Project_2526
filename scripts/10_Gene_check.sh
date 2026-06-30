#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=128g
#SBATCH --time=8:00:00
#SBATCH --job-name=10_Gene_Check
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bedtools-uoneasy/2.31.0-GCC-12.3.0
#loads bedtools slurm module

usage(){
  echo "Usage: sbatch [slurm-options] $0 [options]"
  echo
  echo "Options:"
  echo "  -b, --bed		Input vcf file"
  echo "  -g, --gff		nnotation file in a gff format"
  echo "  -o, --out		Output file"
  echo "  -h, --help	Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in

    -b|--bed)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      BED="$2" 
      shift 2 ;;

    -g|--gff)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      $GFF="$2"
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

GENES_BED=tmp_genes.bed

sortBed -i $GFF | gff2bed --max-mem 128G > $GENES_BED

bedtools intersect \
-a $BED \
-b $GENES_BED \
-wo > $OUT

rm $GENES_BED
