#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=4:00:00
#SBATCH --job-name=04b_scaffolding
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies`
#Activates conda env

usage(){
  #Help message for the script
  echo "Usage: sbatch $0 [options]"
  echo
  echo "Options:"
  echo "  -f, --reference   Reference, chromsome-level scaffolded FASTA file"
  echo "  -t, --target      Target FASTA file to be rescaffolded"
  echo "  -o, --out         Output directory for ragtag"
  echo "  -g, --gff         Annotation file as a gff to be transfered"
  echo "  -go, --gff-out    Output file for the updated gff"
  echo "  -h, --help        Show this help message"
}

#Argument handling
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--reference)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      REF="$2"
      shift 2 ;;
      #Sets -f to REF. This should be the reference FASTA file with chromosome-level scaffolding

    -t|--target)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      TARGET="$2"
      shift 2 ;;
      #Sets -t to TARGET. This should be the FASTA file that is wanted to be rescaffolded

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT_DIR="$2" 
      shift 2 ;;
      #Sets -o to OUT. This should be the output directory for RagTag

    -g|--gff)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      GFF="$2" 
      shift 2 ;;
      #Sets -g to GFF. This should be the GFF file for the target FASTA

    -go|--gff-out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      GFF_OUT="$2" 
      shift 2 ;;
      #Stes -go to GFF_OUT. This is the output file for the rescaffolded annotation file

    -h|--help)
      usage
      exit 0
      ;;
      #Runs usage()

    *) echo "Invalid option: $1" 
      exit 1 ;;
      #Error handling for incorrect options
  esac
done

mkdir -p $OUT_DIR #Makes output directory

ragtag.py scaffold -o $OUT_DIR $REF $TARGET #Runs Ragtag. Outputs to OUT_DIR. Transfers scafflod structure from REF to TARGET

AGP="$OUT_DIR"ragtag.scaffold.agp #Locates the AGP file for the RagTag scaffold

ragtag.py updategff $GFF $AGP > $GFF_OUT
#Updates GGF file to the new scaffolding using the AGP file



