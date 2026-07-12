# 4138_Hoverfly_Project_2526

## Introduction

Batesian mimicry is when a palatable prey species mimics the appearance of an unpalatable species to avoid predation.
One such batesian mimic is the hoverfly *Volcuella bombylans*, which mimic bumblebees.
There are two main morphs of *V. bombylans* (*V. bombylans plumata*, and *V. bombylans bombylans*).
Each morph mimics a different group of bumblebee species.
The plumata morph mimics black and yellow bumblebees (*Bombus lucorum*, *Bombus terrestris*, and *Bombus hortorum*).
The bomyblans morph mimics red-tailed black and yellow bumblebees (*Bombus lapidarius*).

Currently there is no know understanding of the genetic factors which contibute to colour polymorphism.

In this project we aim to understand the causues of genetic polymorphism within *V. bombylans*.

## Repository layout

This repository contains two directories.

  - scripts
  - additional_scripts

#### scripts

Contains all scripts used in this project.

#### additional_scripts

Contains aditional scripts which are not part of the the main pipeline.
These do not use a SLURM task manager. Many of them are used to create the .txt files required by some of the scripts in the main pipeline.

## Software

The environments provided contain the following software, each is provided with the version.

| Tool name   | Version  | Link |
|-------------|----------|------|
| FastQC      | 0.12.1   | https://github.com/s-andrews/FastQC |
| multiqc     | 1.0.dev0 | https://github.com/MultiQC/MultiQC |
| fastp       | 0.23.4   | https://github.com/opengene/fastpbwa |
| bwa         | 0.7.19   | https://github.com/lh3/BWA |
| samtools    | 1.18     | https://github.com/samtools/samtools |
| picard      | 3.0.0    | https://github.com/broadinstitute/picard |
| bcftools    | 1.19     | https://github.com/samtools/bcftools |
| seqkit      | 2.13.0   | https://github.com/shenwei356/seqkit |
| biopython   | 1.87     | https://github.com/biopython/biopython |
| plink       | 1.90b7.7 | https://github.com/chrchang/plink-ng |
| bedtools    | 2.31.0   | https://github.com/arq5x/bedtools2 |
| hdf5        | 1.12.2   | https://github.com/HDFGroup/hdf5 |
| gff2bed     | 1.0.3    | https://gitlab.com/salk-tm/gff2bed |

# Script Overview and Usage
## scripts
#### 01_QC.sh

This script runs FastQC on the fastq files within a directory. It will produce a .html report file and a zipped directory containing the report data.

```
Usage: sbatch [slurm-options] 01_QC.sh [options]

slurm-options:
--array=			Array range for the number of files

Options:
-q, --fastq		Input FASTQ directory
-o, --out			Output directory
-n, --names		A .txt file containg the names of the fastq files
-h, --help    Show this help message
```

The QC report files will all be outputted into the provided directory.

The script requires a .txt file containing a list of all files in the input directory.
This can be obtained using `get_names.sh`. An example layout of the file is below.

```
VB20001_R1.fastq.gz
VB20001_R2.fastq.gz
VB20002_R1.fastq.gz
VB20002_R2.fastq.gz
VB20003_R1.fastq.gz
VB20003_R2.fastq.gz
VB20004_R1.fastq.gz
VB20004_R2.fastq.gz
```

An example use of the script is below.

```
sbatch --array=0-3 01_QC.sh \ #Runs script with an array of 4
  -q ~/hoverflies/fastq_files/ \ #Provides the directory with the fastq files
  -o ~/hoverflies/QC/ \ #Sets the output directory
  -n ~/hoverflies/fastq_names.txt #Provides the file with the list of fastq files
```

#### 02_multiqc.sh

Uses multiqc to compile the report files from `01_QC.sh` into one report.

```
Usage: sbatch 02_multiqc [options]"

Options:"
-q, --fastq		Input FASTQ directory
-o, --out			Output directory
-h, --help		Show this help message
```

An example usage of the script is below

```
sbatch 02_multiqc.sh -q ~/hoverflies/QC/ \ #Sets where the QC files out
  -o ~/hoverflies/QC/multi_qc/ #Sets the output for multiqc
```

#### 03_trim.sh

A trimming script for the fastq files. It takes a directory contain fastq files, alongside a .txt file containg the file root names and trimms all files.
The trimmed fastq files are outputted to provided directory.

```
Usage: sbatch [slurm-options] 03_trim.sh [options]

slurm-options:
  --array=			Array range for the number of samples

Options:
  -q, --fastq		Input FASTQ directory
  -o, --out			Output directory
  -r, --roots		A .txt file containg the roots of the fastq files
  -h, --help		Show this help message
```

The array size should be for the number of samples. This will be the same as the number of lines in the provided roots file.

This script requires a file containing the roots of all the fastq files. This can be obtained by using `get_roots.sh`.
An example file is shown below.

```
VB20001
VB20002
VB20003
VB20004
```

The input file extenions must be in the standard illumina format (`_R1.fastq.gz` for the forward reads, and  `_R2.fastq.gz` for the reverse reads.)

The files will be outputted into the provided directory. If the directory does not already exist, it will be made. 
The output files will have the file extension `.trimmed.fastq.gz`.

An example use of the script is below.

```
sbatch --array=0-3 03_trim.sh \ #Runs the script with an array of 4
  -q ~/hoverflies/fastq_files/ \ #Sets thelocation of the fastq files
  -o ~/hoverflies/trimmed_fastqs/ \ #Sets the output location for the trimmed fastq files
  -r ~/hoverflies/fastq_roots.txt #Provides the roots of all the fastq files
```

#### 04a_scaffolding.sh

Three of the used assemblies were not arranged by chromosomes.
This script uses ragtag to scaffold those assemblies in the same arrangement as the main assembly.
It takes a target assembly, alongside a reference assembly to do this.
It will also produce a reformatted GFF file for the scaffolded assembly.

```
Usage: sbatch 04a_scaffolding.sh [options]

Options:
  -f, --reference	Input vcf file
  -t, --target    A .txt file with window sizes wanting to be tested
  -o, --out       Output directory for ragtag
  -g, --gff       Annotation file as a gff to be transfered
  -go, --gff-out  Output file for the updated gff
  -h, --help      Show this help message
```

An example use of the script is below.

```
sbatch 04a_scaffolding.sh -f ~/hoverflies/references/reference_main.fasta \ #Sets refrence assembly
  -t ~/hoverflies/references/reference_alternate.fasta \ #Sets target assembly
  -o ~/hoverflies/scaffolds/alternate/ \ #Sets the output directory
  -g ~/hoverflies/references/reference_alternate.gff \ #Selects GFF to be remapped
  -go ~/hoverflies/scaffolds/alternate/scaffold_alterante.gff #Sets output file for the new GFF
```

This produces a fasta file named `ragtag.scaffold.fasta`.
RagTag also produces an AGP file to which is used to produce the rescaffolded GFF file.

The scaffolded chromosomes will carry the suffix '_RagTag'.

#### 04b_BAM_prep.sh

Indexes references fasta files to make them suitable for use in the next script.

```
Usage: sbatch 04_BAM_prep.sh [options][refrence]

Options:
  -h, --help		Show this help message
  [reference]		The refrence file needing to be indexed
```

The provided fasta file must not be gzipped.

#### 05_make_BAM.sh

Makes BAM files from fastq files. Takes an input directory containing fastq files, 
an indexed reference file, and a .txt file containg the roots of the fastq files.
This will produce BAM files of all samples in the roots file.
Duplicates reads will be removed.

```
Usage: sbatch [slurm-options] 05_make_BAM.sh [options]

slurm-options:
  --array=					Array range for the number of samples

Options:
  -q, --fastq				Input fastq directory
  -f, --reference		Indexed reference genome in a fasta format
  -o, --out					Output directory
  -r, --roots				A .txt file containg the roots of the fastq files
  -h, --help				Show this help message
```

The array size should be for the number of samples. This will be the same as the number of lines in the provided roots file.

This script requires a file containing the roots of all the fastq files. This can be obtained by using `get_roots.sh`.
An example file is shown below.

```
VB20001
VB20002
VB20003
VB20004
```

The produced BAM files will be outputted into the provided directory. If the directory does not exist it will be made.
The files will have the extension `.rmd.bam`.

An example use of the script is below.

```
sbatch --array=0-3 05_make_bam.sh \ #Starts the script and sets the array
  -q ~/hoverflies/trimmed/ \ #Sets the input fastq directory
  -f ~/hoverflies/reference/idVolBomb.fasta \ #Sts the reference fasta file
  -o ~/hoverflies/BAM/ #Sets the output directory
  -r ~/hoverflies/roots.txt #Sets the file containing roots
```

#### 06_VCF.sh

Conducts variant calling on the BAM files to produce a single gzipped VCF file.
It takes an indexed reference fasta, and a .txt file with the full path and name of any BAM files.
The output directory and output file name are provided separately.
The produced VCF file will be indexed.

```
Usage: sbatch 06_VCF.sh [options]

Options:
  -q, --fastq           Input FASTQ directory
  -f, --reference       Refernce genome in a fasta format
  -v, --vcf             File name for VCF ouput
  -b, --bams            A .txt file with the full file paths and names of the BAM files
  -o, --out_directory   Output directory
  -h, --help            Show this help message
```

An example use of this script is below.

```
sbatch 06_VCF.sh -b ~/path/bams.txt \ #Runs scripts and sets the bam files
  -f ~/hoverflies/references/idVolBomb.fasta \ #Sets the reference file
  -v VB.vcf.gz \ #Sets the name of the VCF output
  -o ~/hoverflies/VCF/ #Sets the output directory
```

#### 07_VCF_Chrom_Select.sh

Removes the non-chromosomal contigs from the VCF file.
Keeps the chromosomes which are provided in a .txt file as comma separated list.

```
Usage: sbatch [slurm-options] 07_VCF_Chrom_Select.sh [options]

Options:
  -v, --vcf				Input vcf file
  -c, --chr_file	Comma seperated file with the names of the wanted chromosomes
  -o, --out				Output file
  -h, --help			Show this help message
```

The file with the commaseparted list will need the full chromosome names of what you want to include in the VCF file.
An example is below.

```
OX422140.1,OX422141.1,OX422142.1,OX422143.1,OX422144.1,OX422145.1
```

#### 08_VCF_filter.sh

Filters a VCF file based on chosen parameters. It filters by minor allele count, missingness, quality, minimum depth, and maximum depth.

```
Usage: sbatch 08_VCF_filter.sh [options]

Options:
  -v, --vcf               Input VCF file
  -o, --out               Output file in a vcf.gz format
  -m, --mac               Minor alllel count filter
  -M, --max-missing       Missingness filter
  -Q, --quality           Quality filter
  -d, --min-depth         Minimum depth filter
  -D, --max-depth         Maximum depth filter
  -bo, --biallelic-out    Output file for biallic only VCF file
  -h, --help              Show this help message
```

All filters are passed in as numerical values.

Two filtered VCF files are made by the script.
The first is filtered by the given criteria and passed through as --out, while the second keeps only the biallelic SNPS and is assigned to --biallelic-out.

#### 09_FST_scan.sh

Carries out fixation index scanning on a provided VCF file.
Takes text files of the paths for the different populations, containing the full path to the BAM files.

```
Usage: sbatch [slurm-options] 09_FST_scan.sh [options]

slurm-options:
  --array=                Input array range for the number of windows to be tested

Options:
  -v, --vcf               Input vcf file
  -w, --windows           A .txt file with window sizes wanting to be tested
  -p1, --population1      A file containg the full paths of the BAM files for the samples in a specific population
  -p2, --population2      A file containg the full paths of the BAM files for the samples in a specific population
  -p3, --population3      A file containg the full paths of the BAM files for the samples in a specific population
  -o, --out               Output directory
  -h, --help              Show this help message
```

#### 10_Region_select.sh

Crops a VCF file to contain only a specific region.

```
Usage: sbatch 10_Region_select.sh [options]

Options:
  -v, --vcf       Input vcf file
  -r, --region		Selected region to filter
  -o, --out       Output vcf file
  -h, --help      Show this help message
```

Example usage is below.

```
sbatch 10_Region_select.sh -v ~/hoverflies/VCF/VB.vcf.gz \
  -r OX422140.1:75000000-100000000 \
  -o ~/hoverflies/VCF/VB.85M.vcf.gz
```

#### 11_Gene_check.sh

Takes a .bed file and finds the genes which are within the region from a GFF file

```
Usage: sbatch [slurm-options] 10_Gene_check.sh [options]

slurm-options:
  --array=		Input array range for the number of windows to be tested

Options:
  -b, --bed		Input vcf file
  -g, --gff		nnotation file in a gff format
  -o, --out		Output directory
  -h, --help	Show this help message
```

The input GFF file does not need to be sorted

It outputs the file in a GFF format.
This will contain any genomic features which over lap with the coordinates in the bed file.

Example usage can be seen below.

```
sbatch 11_Gene_check.sh -b ~/hoverflies/ROI.bed \
  -g ~/hoverflies/scaffolds/alternate/scaffold_alterante.gff \
  -o ~/hoverflies/genes_in_region.gff
```

## additional_scripts

#### gc_filter.py and gc_filter.sh

Filters the reads within a FASTQ file based on their GC content.
Outputs the reads to a FASTA format.
`gc_filter.sh` is used to run the script. It is provided with arguments which it passes into `gc_filter.py`. 
`gc_filter.py` does not need to be ran on its own. Below is the usage for `gc_filter.sh`.

```
Usage: sbatch [slurm-options] gc_filter.sh [options]

slurm-options:
  --array=      Input array range for the number of windows to be tested

Options:
  -f, --fastq   Directory containing the FASTQ files
  -n, --names   File containging the name and extension of the FASTQS of interest
  -m, --min-GC  The minmum value of GC content to be filtered for
  -M, --max-GC  The maximum value of GC content to be filtered for"
  -o, --out     Output directory
  -h, --help    Show this help message
```

The inputted FASTA files can be gzipped.
Outputs a FASTA file containing the reads which meet the filter requirements.

Example usage is show below.

```
sbatch --array=0-1 gc_filter.sh -f ~/hoverflies/trimmed/ \
  -n ~/hoverflies/to_filter.txt \
  -m 0.65 \
  -M 0.75 \
  -o ~/hoverflies/high_GC/
```

#### get_bams.sh

Creates a text file with the full filepath to files in a specified directory, and outputs it to a .txt file.
This script does not require the use of the SLURM job manager.

```
Usage: ./get_bams [options]

Options:
  -d, --directory    Path to the directory containing the bam files
  -o, --out    Output file
  -h, --help   Show this help message
```

This script can be used to get the BAM file needed for BCFtools mpileup in `06_VCF.sh`.

#### get_chrs.sh

Creates a text file containing all the chromosomes within a reference FASTA file. It returns all contigs which start with "OX".
It outputs this to a .txt file, as a comma separted list.
This script does not require the use of the SLURM job manager.

```
Usage: ./get_chrs.sh [options]

Options:
  -f, --reference    Input reference file as a fasta
  -o, --out          Output file
  -h, --help         Show this help message
```

This script can be used before `07_VCF_Chrom_Select`. This is used as the regions to filter for by BCFtools view.

#### get_names.sh

Returns file names of gzipped FASTQ files within a specified directory. This outputs them to a .txt file.
This script does not require the use of the SLURM job manager.

```
Usage: ./get_names.sh [options]

Options:
  -d, --directory    Path to the directory containing the fastq files
  -o, --out          Output file
  -h, --help         Show this help message
```

This script can be used before `01_QC.sh` to get the file needed for the array.

#### get_roots.sh

Returns the roots of all gzipped FASTQ files within a specified directory. It removes the full file path and file extension from the files. It outputs this to a .txt file.
This script does not require the use of the SLURM job manager.

```
Usage: ./get_roots.sh [options]

Options:
  -d, --directory    Path to file containg fastqs
  -o, --out          Output file
  -h, --help         Show this help message
```

This script can be used to get the roots file needed for `03_trim.sh` and `05_make_BAM.sh`.
