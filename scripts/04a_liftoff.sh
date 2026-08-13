#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12g
#SBATCH --time=48:00:00
#SBATCH --job-name=04a_liftoff
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

usage(){
  #Help message for the script
  echo "Usage: $0 [options]"
  echo
  echo "Options:"
  echo "  -t, --target      Target reference fasta"
  echo "  -f, --refernce    reference fasta file to lift annotations from"
  echo "  -g, --gff         gff annotation file to lift genes from"
  echo "  -o, --out         Output file for the liftoff gff"
  echo "  -h, --help        Show this help message"
}

#Argument handling
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--target)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      TARGET="$2"
      shift 2 ;;
      #Sets -t to to TARGET. Should be to target FASTA to reciueve annotation

    -f|--reference)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      REF="$2" 
      shift 2 ;;
      #Sets -f to REF. Should be the reference FASTA for the model GFF

    -g|--gff)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      GFF="$2" 
      shift 2 ;;
      #Sets -g to GFF. This is the model GFF to lift the annotations from

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT="$2" 
      shift 2 ;;
      #Sets -o to OUT. This should be the output GFF file for the annotations to be lifted to.

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


liftoff -g $GFF \
	-o $OUT \
	-u unmapped.gff \
	-p 8 \
	$TARGET \
	$REF
