#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=128g
#SBATCH --time=48:00:00
#SBATCH --job-name=06_VCF
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

module load bcftools-uoneasy/1.19-GCC-13.2.0
#Loads slurm modulesql

usage(){
  #Help message for the script
  echo "Usage: sbatch $0 [options]"
  echo
  echo "Options:"
  echo "  -q, --fastq           Input FASTQ directory"
  echo "  -f, --reference       Refernce genome in a fasta format"
  echo "  -v, --vcf             File name for VCF ouput"
  echo "  -o, --out_directory   Output directory"
  echo "  -h, --help            Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
    -q|--fastq)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      SAMPLE_DIR="$2"
      shift 2 ;;
      # Sets -q to $SAMPLE_DIR. Should be a directory containg the sample fastq files

    -f|--reference)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      REF="$2"
      shift 2 ;;
      # Sets -r to $REF. Should be an indexed reference .fasta file

    -v|--vcf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCF="$2"
      shift 2 ;;
      # Sets -v to $VCF. SHould be the file name for the output

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT_DIR="$2" 
      shift 2 ;;
      # Sets -o to $OUT_DIR. Should be the output directory

    -b|--bams)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      BAMS="$2" 
      shift 2 ;;
      # Sets -b to $BAMS. Should be a .txt file with the fule paths of all BAM files

    -h|--help)
      usage
      exit 0
      ;;
      # Runs usage

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done

mkdir -p $OUT_DIR #Creates $OUT_DIR if it does exist
cd $OUT_DIR #Enters $OUT_DIR

bcftools mpileup \
  --threads 20 \
  -Ou \
  -f "$REF" \
  --min-MQ 20 \
  --min-BQ 30 \
  --platforms ILLUMINA \
  --annotate FORMAT/DP,FORMAT/AD \
  --bam-list "$BAMS" | \
bcftools call \
  --threads 20 \
  -m \
  -v \
  -a GQ,GP \
  -Oz \
  -o "$VCF"
#Generates VCF files

bcftools index $VCF
#Indexes VCF
