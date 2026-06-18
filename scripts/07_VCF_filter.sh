#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=8:00:00
#SBATCH --job-name=08_VCF_filter
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0
#loads BCFtools slurm module

usage(){
  #Help message for the script
  echo "Usage: sbatch $0 [options]"
  echo
  echo "Options:"
  echo "  -v, --vcf           Input VCF file"
  echo "  -o, --out           Output file in a vcf.gz format"
  echo "  -m, --mac"
  echo "  -M, --max-missing"
  echo "  -Q, --quality"
  echo "  -d, --min-depth"
  echo "  -D, --max-depth"
  echo "  -bo, --biallelic-out    "
  echo "  -h, --help          Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--vcf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCF="$2"
      shift 2 ;;


    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT="$2" 
      shift 2 ;;
      # Sets -o to $OUT. Should be the output filtered VCF file

    -m|--mac)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MAC="$2" 
      shift 2 ;;
      # Sets -m to $MAC. Should be the filter setting for MAC

    -M|--miss)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MISS="$2" 
      shift 2 ;;
      # Sets -M to $MISS. Should be the filter setting for missinginess

    -Q|--quality)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      QUAL="$2" 
      shift 2 ;;
      # Sets -Q to $QUAL. Should be the quality filter

    -d|--min-depth)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MIN_DEPTH="$2" 
      shift 2 ;;
      # Sets -d to $MIN_DEPTH. Should be the minimum depth filter

    -D|--max-depth)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MAX_DEPTH="$2" 
      shift 2 ;;
      # Sets -D to $MAX_DEPTH. Should be the minimum depth filter

    -bo|--biallelic-out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCFB="$2" 
      shift 2 ;; 
      # Sets -bo to $VCFB. Should be the output for the biallelic only VCF

    -h|--help)
      usage
      exit 0
      ;;
      # Runs usage

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done

vcftools --gzvcf $VCF \
	--remove-indels \
	--mac $MAC \
	--max-missing $MISS \
	--minQ $QUAL \
	--min-meanDP $MIN_DEPTH \
	--max-meanDP $MAX_DEPTH \
	--minDP $MIN_DEPTH \
	--maxDP $MAX_DEPTH \
	--recode \
	--stdout | bgzip -c > \
	$OUT
#Filters $VCF with VCF tools. Filters determined by above options

bcftools index $OUT
#Indexes $OUT

bcftools view -Oz --max-alleles 2 --exclude-types indels -o $VCFB $VCF
#Removes indels and keeps only biallelic varients

bcftools index $VCFB
#Indexes $VCFB

bcftools view -H $VCFB | wc -l > $VCFB.SNPS.txt
#Outpus number of SNPS to $VCFB.SNPS.txt
