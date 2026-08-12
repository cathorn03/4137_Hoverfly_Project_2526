# scripts

This contains an overview of all scripts used in the main analytical pipeline for the project. It provides a description of the script, the arguemnts required to run the script, example usage of some scripts. It also provides example formats of any additional files, which are needed for the scripts. Several of these can be made directly using the scripts within `additional_scripts`. 

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
sbatch --array=0-3 01_QC.sh \       #Runs script with an array of 4
  -q ~/hoverflies/fastq_files/ \    #Provides the directory with the fastq files
  -o ~/hoverflies/QC/ \             #Sets the output directory
  -n ~/hoverflies/fastq_names.txt   #Provides the file with the list of fastq files
```

#### 02_multiqc.sh

Uses MultiQC to compile the report files from `01_QC.sh` into one report.

```
Usage: sbatch 02_multiqc [options]"

Options:"
-q, --fastq		Input FASTQ directory
-o, --out			Output directory
-h, --help		Show this help message
```

An example usage of the script is below

```
sbatch 02_multiqc.sh -q ~/hoverflies/QC/ \   #Sets where the QC files out
  -o ~/hoverflies/QC/multi_qc/               #Sets the output for multiqc
```

#### 03_trim.sh

A trimming script for the fastq files. It takes a directory contain fastq files, alongside a .txt file containg the file root names and trimms all files.
The trimmed fastq files are outputted to provided directory.
The fastq files are trimmed with FastP.

```
Usage: sbatch [slurm-options] 03_trim.sh [options]

slurm-options:
  --array=      Array range for the number of samples

Options:
  -q, --fastq   Input FASTQ directory
  -o, --out     Output directory
  -r, --roots   A .txt file containg the roots of the fastq files
  -h, --help    Show this help message
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
sbatch --array=0-3 03_trim.sh \       #Runs the script with an array of 4
  -q ~/hoverflies/fastq_files/ \      #Sets thelocation of the fastq files
  -o ~/hoverflies/trimmed_fastqs/ \   #Sets the output location for the trimmed fastq files
  -r ~/hoverflies/fastq_roots.txt.    #Provides the roots of all the fastq files
```

#### 04a_liftoff.sh

Lift the GFF from a chosen reference FASTA file to a chosen target FASTA reference file with LiftOff.
Produces a new GFF file for the target FASTA.

```
Usage: 04a_liftoff.sh [options]

Options:
  -t, --target      Target reference fasta
  -f, --refernce    reference fasta file to lift annotations from
  -g, --gff         gff annotation file to lift genes from
  -o, --out         Output file for the liftoff gff
  -h, --help        Show this help message
```

An example use of the script is below.

```
sbatch 04a_liftoff.sh -t ~/hoverflies/references/reference_alternate.fasta \   #Runs script and sets target fasta
  -f ~/hoverflies/references/idVolBomb.fasta \                                 #Sets fasta file for reeference which annotations are bing lifted from
  -g ~/hoverflies/references/idVolBomb.gff \                                   #Sets gff to lift annotations from
  -o ~/hoverflies/reference_alternate.gff                                      #Sets output gff
```

#### 04b_scaffolding.sh

Three of the used assemblies were not arranged by chromosomes.
This script uses RagTag to scaffold those assemblies in the same arrangement as the main assembly.
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
sbatch 04b_scaffolding.sh -f ~/hoverflies/references/reference_main.fasta \   #Sets refrence assembly
  -t ~/hoverflies/references/reference_alternate.fasta \                      #Sets target assembly
  -o ~/hoverflies/scaffolds/alternate/ \                                      #Sets the output directory
  -g ~/hoverflies/references/reference_alternate.gff \                        #Selects GFF to be remapped
  -go ~/hoverflies/scaffolds/alternate/scaffold_alterante.gff                 #Sets output file for the new GFF
```

This produces a fasta file named `ragtag.scaffold.fasta`.
RagTag also produces an AGP file to which is used to produce the rescaffolded GFF file.

The scaffolded chromosomes will carry the suffix `_RagTag`.

#### 04c_BAM_prep.sh

Indexes references fasta files to make them suitable for use in the next script.

```
Usage: sbatch 04c_BAM_prep.sh [options][refrence]

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
BAMS are made using BWA, Picard, and SAMtools. 

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
sbatch --array=0-3 05_make_bam.sh \             #Starts the script and sets the array
  -q ~/hoverflies/trimmed/ \                    #Sets the input fastq directory
  -f ~/hoverflies/reference/idVolBomb.fasta \   #Sets the reference fasta file
  -o ~/hoverflies/ref_BAM/ \                        #Sets the output directory
  -r ~/hoverflies/roots.txt                     #Sets the file containing roots
```

#### 06_VCF.sh

Conducts variant calling on the BAM files to produce a single gzipped VCF file.
It takes an indexed reference fasta, and a .txt file with the full path and name of any BAM files.
The output directory and output file name are provided separately.
The produced VCF file will be indexed.
The VCF files are made and indexed using BCFtools

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
sbatch 06_VCF.sh -b ~/hoverflies/ref_bams.txt \            #Runs scripts and sets the bam files
  -f ~/hoverflies/references/idVolBomb.fasta \   #Sets the reference file
  -v ref_VB.vcf.gz \                             #Sets the name of the VCF output
  -o ~/hoverflies/VCF/                           #Sets the output directory
```

#### 07_VCF_Chrom_Select.sh

Removes the non-chromosomal contigs from the VCF file, using BCFtools.
Keeps the chromosomes which are provided in a .txt file as comma separated list.

```
Usage: sbatch 07_VCF_Chrom_Select.sh [options]

Options:
  -v, --vcf				Input vcf file
  -c, --chr_file	Comma seperated file with the names of the wanted chromosomes
  -o, --out				Output file
  -h, --help			Show this help message
```

The file with the commaseparted list will need the full chromosome names of what you want to include in the VCF file. This can be obtained by using `get_chrs.sh`.
An example is below.

```
OX422140.1,OX422141.1,OX422142.1,OX422143.1,OX422144.1,OX422145.1
```

An example use of this script is below.

```
sbatch 07_VCF_Chrom_Select.sh -v ~/hoverflies/VCF/ref_VB.vcf.gz \   #Runs script and sets input vcf
  -c ~/hoverflies/chrs.txt \                                        #Sets the file containg the comma separated list of chromosomes
  -o ~/hoverflies/VCF/ref_VB.chrs.vcf.gz                            #Sets the output file
```

#### 08_VCF_filter.sh

Filters a VCF file based on chosen parameters. It filters by minor allele count, missingness, quality, minimum depth, and maximum depth.
Initial filtering is carried out using VCFtools, while multiallelic removal is carried out through BCFtools.

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

An example use of this script is below.

```
sbatch  08_VCF_filter.sh -v ~/hoverflies/VCF/ref_VB.vcf.gz \   #Runs script and sets input vcf to be filtered
  -m 3 \                                                       #Sets minor allele count to 3
  -M 0.8 \                                                     #Sets max-missingness to 80%
  -Q 30 \                                                      #Sets minimum quality score to 30
  -d 5 \                                                       #Sets minimum depth to 5
  -D 50 \                                                      #Sets maximum depth to 50
  -o ~/hoverflies/VCF/ref_VB.chrs.80.vcf.gz \                  #Sets output file for filtered vcf
  -bo ~/hoverflies/VCF/ref_VB.chrs.80b.vcf.gz                  #Sets output file for filtere, biallelic only vcf
```

#### 09_FST_scan.sh

Carries out fixation index scanning on a provided VCF file.
Takes text files of the paths for the different populations, containing the full path to the BAM files.
F<sub>ST</sub> calculations are carried out using VCFtools.

```
Usage: sbatch  09_FST_scan.sh [options]

Options:
  -v, --vcf               Input vcf file
  -w, --windows           ize of sliding window for scan
  -s, --step-size         Step size for the window to take
  -p1, --population1      A file containg the full paths of the BAM files for the samples in a specific population
  -p2, --population2      A file containg the full paths of the BAM files for the samples in a specific population
  -o, --out               Output directory
  -p, --prefix            Prefix for the output file name
  -h, --help              Show this help message
```

An example use of this script is below.

```
sbatch 09_FST_scan.sh -v ~/hoverflies/VCF/ref_VB.chrs.80b.vcf.gz \   #Runs script and sets input vcf
  -w 50000 \                                                #Sets window size to 50 kb
  -s 10000 \                                                #Sets step size to 10 kb
  -p1 ~/hoverflies/bombylans.txt                            #Sets population 1 file
  -p2 ~/hoverflies/plumata.txt                              #Sets population 2 file
  -o ~/hoverflies/fst/                                      #Sets ouput directory
  -p "ref_50k"                                              #Sets the prefix for the output file
```

#### 10_Region_select.sh

Crops a VCF file to contain only a specific region. This script does so using BCFtools view. It will index the outputed VCF file.

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
sbatch 10_Region_select.sh -v ~/hoverflies/VCF/ref_VB.chrs.80b.vcf.gz \  #Runs script and sets input vcf
  -r OX422140.1:75000000-100000000 \                                     #Sets region to retain 
  -o ~/hoverflies/VCF/ref_VB.87M.vcf.gz                                  #Sets output file
```

#### 11_Gene_check.sh

Takes a .bed file and finds the genes which are within the region from a GFF file, using BEDtools.

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
sbatch 11_Gene_check.sh -b ~/hoverflies/ROI.bed \                #Runs script and sets BED file contain region to search in annotation file
  -g ~/hoverflies/scaffolds/alternate/scaffold_alterante.gff \   #Sets annotation file to search in 
  -o ~/hoverflies/genes_in_region.gff                            #Sets output gff file for any identfied annotations
```

#### 12_SV_detection.sh

Scans for structural variants within provided BAM files and outputs this to a VCF file, using dysgu

```
Usage: sbatch 2_SV_detection.sh [options]

Options:
  -f, --reference   Refernce files
  -b, --BAM         BAM files to produce VCF files from
  -o, --out_dir     Output directory
  -v, --vcf         Output file name
  -t, --temp_dir    Directory for temporary files
  -h, --help        Show this help message
```

An example use of this script is below.

```
sbatch 12_SV_detection.sh -f ~/hoverflies/references/idVolBomb.fasta \
  -f ~/hoverflies/ref_BAM/ \
  -o ~/hoverflies/SV/ \
  -v ref_VB.SV.vcf.gz \
  -t ~/hoverflies/dysgu_temp
```

#### 13_INV_filter.sh

Filters the structural variant VCF file for only inversions. 

```
Usage: sbatch 13_INV_filter.sh [options]

Options:
  -t, --type    Type of SV to filter for
  -v, --vcf     VCF file to filter
  -o, --out     Output file
  -h, --help    Show this help message
```

#### analysis.r

This script produces the plots and carries out the analysis for the project. It is an R script to be ran on a PC. It produces, FST plots, genotype plots and PCA plots for each assembly. It requires the outputs of the F<sub>ST</sub> scan, VCF files for the potential canddiate regions, population map files and covariate files.

The population map files should contain the individual ID of the samples and the population (morph) they belong too. This should be in a tab separated format. The columns should be named `ind` and `pop`. An example is below. If IDs differ between assemblies, different population maps are needed for each assembly.

```
ind pop
/gpfs01/home/mbyct9/Thesis/plumata_BAM/VB20001.rmd.bam  bombylans
/gpfs01/home/mbyct9/Thesis/plumata_BAM/VB20002.rmd.bam  bombylans
/gpfs01/home/mbyct9/Thesis/plumata_BAM/VB20003.rmd.bam  plumata
/gpfs01/home/mbyct9/Thesis/plumata_BAM/VB20004.rmd.bam  plumata
/gpfs01/home/mbyct9/Thesis/plumata_BAM/VB20005.rmd.bam  plumata
```

The covariate files should contain the individual ID of the samples and the population (morph) they belong too. In this study it also contained sex, longtitude and latitude of collection information. This should be in a comma separated format. An example is below. If IDs differ between assemblies, different population maps are needed for each assembly.

```
Individual,pop,sex,latitude,longitude
/share/hoverflies/Caleb/alt_BAM/VB20001.rmd.bam,bombylans,F,54.467403,-0.6793531
/share/hoverflies/Caleb/alt_BAM/VB20002.rmd.bam,bombylans,F,54.467403,-0.6793531
/share/hoverflies/Caleb/alt_BAM/VB20003.rmd.bam,plumata,M,54.467403,-0.6793531
/share/hoverflies/Caleb/alt_BAM/VB20004.rmd.bam,plumata,M,54.467403,-0.6793531
```