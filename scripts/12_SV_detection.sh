#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=12_SV_detection
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk

source $HOME/.bash_profile
conda activate hoverflies

module load bcftools-uoneasy/1.19-GCC-13.2.0

usage(){
	#Help message for the script
	echo "Usage: sbatch $0 [options]"
	echo
	echo "Options:"
	echo "  -f, --reference   Refernce FASTA file"
	echo "	-b, --BAM         BAM files to produce VCF files from"
	echo "  -o, --out_dir     Output directory"
	echo "  -v, --vcf         Output file name"
	echo "  -t, --temp_dir    Directory for temporary files"
	echo "  -h, --help        Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
		-f|--reference)
	  	[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
	  	REF="$2"
	  	shift 2 ;;
			#Sets -r to $REF. Should be a reference FASTA file

		-b|--BAM)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			BAM="$2" 
			shift 2 ;;
			# Sets -b to BAM. Should be the directory containg the BAM files
		-t|--temp_dir)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			TEMP="$2" 
			shift 2 ;;
			#Sets -t to TEMP. This is the temporary directory for Dysgu

		-o|--out_dir)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			OUT="$2" 
			shift 2 ;;
			# Sets -o to $OUT. Should be the output directory

		-v|--vcf)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			VCF="$2" 
			shift 2 ;;
			#Stes -v to VCF. This should be the output VCF file

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

mkdir -p $OUT #Makes output directory
cd $OUT #Enters output directory

dysgu run -x $REF $TEMP $BAM > $VCF #Runs Dysgu. Uses REF to carry out variant calling on the files in BAM

bgzip $VCF #gzips dysgu output

bcftools index $VCF.gz
#Indexes VCF