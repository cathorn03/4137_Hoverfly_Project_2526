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

# Script Overview and Usage

# Documentation

For script overviews and usage, see each directories' README.md

- [scripts/README.md](./scripts/README.md)
- [scripts/README.md](./additional_scripts/README.md)

# Author

Caleb Thornber
School of Life Sciences
University of Nottingham
mbyct9@nottingham.ac.uk