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
  - env

#### scripts

Primary SLURM pipeline used in the analysis

#### additional_scripts

Contains utility scripts which are not part of the the main pipeline. These are used for generating inpur files and preprocessing. This also contains scripts used for exploratory analysis that do not form part of the main pipeline.

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

## Installation

### Prerequisits

This pipline was developed, and tested on a Linux-based high performance computing cluster using the SLURM workload manager. 

Before running the pipline insure the following software is available:

- Git
- Conda
- SLURM
- Bash

### Clone the Repository

Clone the repository from GitHub:

```
git clone https://github.com/cathorn034138_Hoverfly_Project_2526.git
cd 4138_Hoverfly_Project_2526
```

### Install the Conda Environment

The software required for this pipeline is provided in `enviroment.yml`.

Create the enivronment using:

```
conda env create -f environment.yml
```

Activate the environment using:

```
conda activate hoverflies
```

## Pipeline Overview

### Inputs

This pipline takes raw FASTQ read data from Illumina sequencers. It requires reference assemblies with a complementary GFF file.

### Workflow

The main analysis pipline is in the `scripts/` directory. The scriots are intedned to be run in numerical order. Each script will rpoduce the inputs needed for the subsequent stage. Several scripts require additional files which can be produced from scripts within `./additional_scripts.`.

The pipeline performs the following analysis:

1. Quality control on the raw sequence data
2. Compilation of the quality control reports
3. Trimming of the raw sequence data
4a. Carry over GFF file from one reference to another
4b. Reformat reference files to a structure of a different reference
4c. Index reference files
5. Allignment of reads, and production of BAM files
6. Vsrient calling to produce raw VCFs
7. Removal of non chromosomal varients
8. Filtering of the VCF file
9. Genome wide FST scanning
10. Extraction of regions of interest
11. Identifcation of genetic features overlapping with selected genomic regions

### Outputs

The pipline produces the following outputs:

- Individual fastQC reports for each FASTQ file
- A combined MultiQC report
- Indexed reference genome files
- Duplicate marked, and indexed BAM files
- Indexed VCF files containing:
  - Raw variant calls
  - Chromosomes-only varients
  - Filtered varients
- Genome wide FST scan file
- Gene annotations for candidate regions 

The accompanying R script performs downstream statistical analysis and visualisation.

### Execution

The main pipeline (found in `scritps/`) is to be ran in numerical order. They are designed to be run using the SLURM workload manager. 

The utility scripts in `additional_cripts/` can be run directly from the command line as they do not use the SLURM workload manager.

## Documentation

For script overviews and usage, see each directories' README.md

- [scripts/README.md](./scripts/README.md)
- [additional_scripts/README.md](./additional_scripts/README.md)

## Author

Caleb Thornber
School of Life Sciences
University of Nottingham
mbyct9@nottingham.ac.uk