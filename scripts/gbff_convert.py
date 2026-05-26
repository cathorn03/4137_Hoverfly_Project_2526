#!/usr/bin/env python3

import os
import sys
from BCBio import GFF
from Bio import SeqIO

def gbff_to_gff3(gbff):

    records = SeqIO.parse(gbff, "genbank")
    GFF.write(sys.stdout)

def main():
 	in_gbff = sys.stdin.read()

 	gbff_to_gff3(in_gbff)

if __name__ == "__main__":
	main() 
