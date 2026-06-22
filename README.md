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
Usage: sbatch [slurm-options] $0 [options]

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
VB20005_R1.fastq.gz
VB20005_R2.fastq.gz
```

#### 02_multiqc

Uses multiqc to compile the report files from `01_QC.sh` into one report.

```
Usage: sbatch $0 [options]"

Options:"
-q, --fastq		Input FASTQ directory
-o, --out			Output directory
-h, --help		Show this help message
```

#### 03_trim.sh

A trimming script for the fastq files. It takes a directory contain fastq files, alongside a .txt file containg the file root names and trimms all files.
The trimmed fastq files are outputted to provided directory.

```
Usage: sbatch [slurm-options] $0 [options]

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
VB20005
```

The files will be outputted into the provided directory. If the directory does not already exist, it will be made. 
The output files will have the file extension `.trimmed.fastq.gz`.

#### 04_BAM_prep.sh

Indexes references fasta files to make them suitable for use in the next script.

```
Usage: sbatch $0 [options][refrence]

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
Usage: sbatch [slurm-options] $0 [options]

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
VB20005
```

The produced BAM files ewill be outputted into the provided directory. If the directory does not exist it will be made.
The files will have the extension `.rmd.bam`.

