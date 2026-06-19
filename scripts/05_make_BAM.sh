#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=40g
#SBATCH --time=48:00:00
#SBATCH --job-name=05_make_BAM
#SBATCH --output=/share/hoverflies/Caleb/logsOut/slurm-%x-%j.out
#SBATCH --error=/share/hoverflies/Caleb/logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-42

source $HOME/.bash_profile
conda activate hoverflies
#Activates conda env

module load samtools-uoneasy/1.18-GCC-12.3.0
module load picard-uoneasy/3.0.0-Java-17
#Loads slurm modules

usage(){
	#Help message for the script
	echo "Usage: sbatch [slurm-options] $0 [options]"
	echo
	echo "slurm-options:"
	echo "  --array=					Array range for the number of samples"
	echo
	echo "Options:"
	echo "  -q, --fastq				Input FASTQ directory"
	echo "  -f, --reference		Refernce genome in a fasta format"
	echo "  -o, --out					Output directory"
	echo "  -r, --roots				A .txt file containg the roots of the fastq files"
	echo "  -h, --help				Show this help message"
}

#Option handling
while [[ $# -gt 0 ]]; do
  case "$1" in
  	-q|--fastq)
	  	[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
	  	SAMPLE_DIR="$2"
	  	shift 2 ;;
	  	# Stes -q to $SAMPLE_DIR. Should be a directory containg the sample fastq files

  	-f|--reference)
	  	[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
	  	REF="$2"
	  	shift 2 ;;
	  	# Sets -r to $REF. Should be a reference .fasta file

		-o|--out)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			OUT_DIR="$2" 
			shift 2 ;;
			# Sets -o to $OUT_DIR. Should be the output directory

		-r|--roots)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			ROOT_FILE="$2" 
			shift 2 ;;
			# Sets -r to $ROOT_FILE. Should be a .txt file containing the roots of all the files in $SAMPLE_DIR
			# The file contain sample names for samples in $SAMPLE_DIR without read direction and file extension
			# e.g. /share/hoverflies/fastqs/VB21001_R2.fastq.gz > VB21001

		-h|--help)
			usage
			exit 0
			;;
			# Runs usage

		*) echo "Invalid option: $1" 
			exit 1 ;
			# Error handling for incorrect options
  esac
done

mkdir -p $OUT_DIR
cd $OUT_DIR
# Makes and enters output dir

echo "#### OPTIONS ####"
echo "-q -- $SAMPLE_DIR"
echo "-f -- $REF"
echo "-r -- $ROOTS"

mapfile -t ROOTS < $ROOT_FILE
#Reads file from $ROOT_FILE and assigns to $ROOTS

FQ=${ROOTS[$SLURM_ARRAY_TASK_ID]} 
#Sets file for the array 

FILE1="$SAMPLE_DIR""$FQ""_R1.trimmed.fastq.gz"
FILE2="$SAMPLE_DIR""$FQ""_R2.trimmed.fastq.gz"
#Sets input file names

OUT="$OUT_DIR""$FQ"".sort.bam"
#Sets output file

bwa mem -M -t 16 $REF $FILE1 $FILE2 | \
	samtools view -b | \
	samtools sort -T $FQ -o $OUT
#Makes BAM file

java -Xmx1g -jar $EBROOTPICARD/picard.jar \
MarkDuplicates REMOVE_DUPLICATES=true \
ASSUME_SORTED=true VALIDATION_STRINGENCY=SILENT \
MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
INPUT="$OUT" \
OUTPUT=$FQ.rmd.bam \
METRICS_FILE=$FQ.rmd.bam.metrics
#Runs picard

samtools index $FQ.rmd.bam
#Indexes output

rm $OUT
#Removes plain bam files
