#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=10_Region_select
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

conda activate hoverflies
#Activates conda env

module load bcftools-uoneasy/1.19-GCC-13.2.0
#loads BCFtools slurm module

usage(){
  #Help message for the script
  echo "Usage: sbatch $0 [options]"
  echo
  echo "Options:"
  echo "  -v, --vcf       Input vcf file"
  echo "  -r, --region    Selected region to filter for. Formatted Chr:START-END"
  echo "  -o, --out       Output vcf file"
  echo "  -h, --help      Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--vcf)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      VCF="$2"
      shift 2 ;;
      #Sets -v to $VCF. Should be the input VCF file

    -r|--region)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      REGION="$2"
      shift 2 ;;
      #Sets -r to REGION. This is the region you want to filter for in the VCF. Formatted

    -o|--out)
      [[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
      OUT="$2" 
      shift 2 ;;
      #Sets -o to OUT. This should be the output file.

    -h|--help)
      usage
      exit 0
      ;;
      #Runs usage

    *) echo "Invalid option: $1" 
      exit 1 ;;
      #Error handling for incorrect options

  esac
done

bcftools view --threads 20 -r $REGION -Oz -o $OUT $VCF #Runs BCFtools to filter the VCF for the REGION. Uses 20 cores
bcftools index $OUT #Indexes the output

