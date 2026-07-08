#!/usr/bin/env python3

import os
import sys
from BCBio import GFF
from Bio import SeqIO

def main():

    records = SeqIO.parse(sys.stdin, "genbank")
    GFF.write(records, sys.stdout)

if __name__ == "__main__":
    main()
