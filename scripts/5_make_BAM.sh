#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64g
#SBATCH --time=48:00:00
#SBATCH --job-name=make_BAM
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

PATH_TO=/share/hoverflies/Caleb
#Sets directory paths

mkdir -p $PATH_TO/BAM
cd $PATH_TO/BAM
# Makes and enters output dir

mapfile -t ROOTS < $PATH_TO/roots.txt
#Reads roots.txt and assigns to $ROOTS
#roots.txt contains sample names for samples in /share/hoverflies/fastqs/ without read direction and file extension
#e.g. /share/hoverflies/fastqs/VB21001_R2.fastq.gz > VB21001

FQ=${ROOTS[$SLURM_ARRAY_TASK_ID]} 
#Sets file for the array 

FILE=$PATH_TO/trimmed/$FQ
FILE1=$FILE"_R1.trimmed.fastq.gz"
FILE2=$FILE"_R2.trimmed.fastq.gz"
#Sets input file names

REF=$PATH_TO/references/GCA_949129105.1_idVolBomb1.1_alternate_haplotype_genomic.fna
#Sets reference genome

OUT=$FQ".sort.bam"
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
