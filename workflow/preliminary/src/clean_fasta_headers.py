#!/usr/bin/env python
# -*- coding: utf-8

import sys
import os
import re
import argparse
from Bio.SeqIO.FastaIO import SimpleFastaParser

__description__ = "Clean up fasta headers according to fasta file name as prefix"

def reformat_FASTA(infasta, outfasta):
    prefix = re.sub(".fasta", "", infasta)
    prefix = re.sub(r'[^\w]', '_', prefix)

    contig_count = 1

    if os.path.exists(outfasta):
        os.remove(outfasta)

    with open(outfasta, "w") as outhandle:
        for _, seq in SimpleFastaParser(open(infasta, "r")):

            header = f">{prefix}_{contig_count}\n"

            contig_count += 1

            outhandle.write(header)
            outhandle.write(f"{seq}\n")


def parse_args(args):
    """Argument parsers
    """
    parser = argparse.ArgumentParser(description=__description__)

    parser.add_argument('-i', '--input-fasta-file',
                        required=True,
                        dest = 'infasta',
                        metavar = "INPUT_FASTA",
                        help="Input file path.")

    parser.add_argument('-o', '--output-fasta-file',
                        required=True,
                        dest = 'outfasta',
                        metavar = "OUTPUT_FASTA",
                        help="Output file path.")

    if not args:
        parser.print_help(sys.stderr)
        sys.exit()
    return parser.parse_args(args)

if __name__ == '__main__':
    args = sys.argv[1:]
    args = parse_args(args)

    reformat_FASTA(args.infasta, args.outfasta)
