# additional_scripts

## Utility Scripts

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

## Analysis Scripts

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