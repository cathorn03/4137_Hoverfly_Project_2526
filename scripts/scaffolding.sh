#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=4:00:00
#SBATCH --job-name=scaffolding
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
  echo "  -f, --reference	Input vcf file"
  echo "  -t, --target		A .txt file with window sizes wanting to be tested"
  echo "  -o, --out			Output directory for ragtag"
  echo "  -g, --gff			Annotation file as a gff to be transfered"
  echo "  -go, --gff-out	Output file for the updated gff"
  echo "  -h, --help		Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--reference)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      REF="$2"
      shift 2 ;;

    -t|--target)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      TARGET="$2"
      shift 2 ;;

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MAF="$2" 
      shift 2 ;;

    -g|--gff)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      GFF="$2" 
      shift 2 ;;

    -go|--gff-out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      GFF_OUT="$2" 
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

AGP=$OUT_DIR/ragtag.scaffold.agp

ragtag.py scaffold -o $OUT_DIR $REF $TARGET

ragtag.py updategff \
	$GFF \
	$AGP \
	> $PATH_TO/ragtag/ragtag.scaffold.agp

