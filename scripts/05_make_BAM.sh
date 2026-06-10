#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64g
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
	echo "Usage: sbatch [slurm-options] $0 [options]"
	echo
	echo "slurm-options:"
	echo "  --array=					Array range for the number of samples"
	echo
	echo "Options:"
	echo "  -q, --fastq				Input FASTQ directory"
	echo "  -f  --reference		Refernce genome in a fasta format"
	echo "  -o, --out					Output directory"
	echo "  -r, --roots				A .txt file containg the roots of the fastq files"
	echo "  -h, --help				Show this help message"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  	-q|--fastq)
	  	[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
	  	SAMPLE_DIR="$2"
	  	shift 2 ;;

  	-f|--reference)
	  	[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
	  	REF="$2"
	  	shift 2 ;;

		-o|--out)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			OUT_DIR="$2" 
			shift 2 ;;

		-r|--roots)
			[[ -z "$2" || "$2" == -* ]] && { echo "Missing argument for $1"; exit 1; }
			ROOT_FILE="$2" 
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
cd $OUT_DIR
# Makes and enters output dir

mapfile -t ROOTS < $ROOT_FILE
#Reads roots.txt and assigns to $ROOTS
#roots.txt contains sample names for samples in /share/hoverflies/fastqs/ without read direction and file extension
#e.g. /share/hoverflies/fastqs/VB21001_R2.fastq.gz > VB21001

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
