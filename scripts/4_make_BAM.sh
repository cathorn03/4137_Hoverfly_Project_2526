#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64g
#SBATCH --time=48:00:00
#SBATCH --job-name=make_BAM
#SBATCH --output=./logsOut/slurm-%x-%j.out
#SBATCH --error=./logsErr/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=XXX@nottingham.ac.uk
#SBATCH --array=0-42

# Activates conda env
source $HOME/.bash_profile
conda activate hoverflies

module load samtools-uoneasy/1.18-GCC-12.3.0
module load picard-uoneasy/3.0.0-Java-17

# Makes and enters output dir
mkdir -p BAM
cd BAM

mapfile -t ROOTS < ../roots.txt # Loads in fq file paths

FQ=${ROOTS[$SLURM_ARRAY_TASK_ID]} # Sets file for the array

# Sets input files
FILE=../trimmed/$FQ
FILE1=$FILE"_R1.trimmed.fastq.gz"
FILE2=$FILE"_R2.trimmed.fastq.gz"

REF=../references/GCA_949129095.1_idVolBomb1.1_genomic.fna # Sets reference genome

OUT=$FQ".sort.bam" # Sets output file

bwa mem -M -t 16 $REF $FILE1 $FILE2 | \
	samtools view -b | \
	samtools sort -T $FQ -o $OUT
# Makes BAM file | 

java -Xmx1g -jar $EBROOTPICARD/picard.jar \
MarkDuplicates REMOVE_DUPLICATES=true \
ASSUME_SORTED=true VALIDATION_STRINGENCY=SILENT \
MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
INPUT="$OUT" \
OUTPUT=$FQ.rmd.bam \
METRICS_FILE=$FQ.rmd.bam.metrics

samtools index $FQ.rmd.bam

rm $OUT
