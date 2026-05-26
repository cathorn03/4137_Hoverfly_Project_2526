#!/usr/bin/env python3

from BCBio import GFF
from Bio import SeqIO

def gbff_to_gff3(gbff):

    records = SeqIO.parse(input_file, "genbank")
    GFF.write(sys.stdout)

def main():
 	in_gbff = sys.stdin.read()

 	gbff_to_gff3(in_gbff)

if __name__ == "__main__":
	main() 