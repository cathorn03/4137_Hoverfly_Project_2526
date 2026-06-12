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
  echo "Usage: sbatch $0 [options]"
  echo
  echo "Options:"
  echo "  -v, --vcf           Input VCF file"
  echo "  -o, --out           Output file in a vcf.gz format"
  echo "  -m, --maf"
  echo "  -M, --max-missing"
  echo "  -Q, --quality"
  echo "  -d, --min-depth"
  echo "  -D, --max-depth"
  echo "  -h, --help          Show this help message"
}

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

    -m|--maf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MAF="$2" 
      shift 2 ;;

    -M|--miss)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MISS="$2" 
      shift 2 ;;

    -Q|--quality)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      QUAL="$2" 
      shift 2 ;;

    -d|--min-depth)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MIN_DEPTH="$2" 
      shift 2 ;;

    -D|--max-depth)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      MAX_DEPTH="$2" 
      shift 2 ;;

    -b|--biallelic)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCFB="$2" 
      shift 2 ;; 

    -h|--help)
      usage
      exit 0
      ;;

    *) echo "Invalid option: $1" 
      exit 1 ;;
  esac
done

vcftools --gzvcf $VCF \
	--remove-indels \
	--maf $MAF \
	--max-missing $MISS \
	--minQ $QUAL \
	--min-meanDP $MIN_DEPTH \
	--max-meanDP $MAX_DEPTH \
	--minDP $MIN_DEPTH \
	--maxDP $MAX_DEPTH \
	--recode \
	--stdout | bgzip -c > \
	$OUT

bcftools index $OUT

bcftools view -Oz --max-alleles 2 --exclude-types indels -o $VCFB $VCF

bcftools index $VCFB

bcftools view -H $VCFB | wc -l > $VCFB.SNPS.txt
