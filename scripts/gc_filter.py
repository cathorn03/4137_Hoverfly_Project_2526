#!/usr/bin/env python3

import os
import sys
from Bio import SeqIO
from Bio.SeqUtils import gc_fraction

def gc_filter(fq, gc_min = 0.4, gc_max = 0.6):



	fq_list = list(SeqIO.parse(fq, "fastq")) #Reads in file as a list

	filtered = [
	    record
	    for record in fq_list
	    if gc_fraction(record.seq) >= gc_min and gc_fraction(record.seq) <= gc_max ]
	#Runs gc filtering on the list

	SeqIO.write(filtered, fq+".tmp", "fasta") #Outputs list to a file
	temp = SeqIO.parse(fq+".tmp", "fasta") #Reads in the new file

	os.remove(fq+".tmp") #Removes the new file

	for record in temp:
		print(record.format("fasta")) #Sends fastq data to stdout

def main():
	fq_in = sys.stdin.read() #Accepts stdin

	gc_filter(fq_in, 0.7, 1) #Runs gc_filter

if __name__ == "__main__":
	main() 