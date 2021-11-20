import sys
import os
import pandas as pd
import re
import json
import argparse
import logging

def read_individual_checkm(checkm_tsv):
    """ Read individual checkm bin summary
    """
    with open(checkm_tsv, "r") as f:
        output = f.read()

    output = re.sub("\n", "", output)
    output = output.split("\t")
    output[1] = re.sub("'", "\"", output[1])
    output[1] = json.loads(output[1])
    
    return output[0], output[1]

def checkms_to_df(checkms):
    """ Read all checkm summaries
    Output into pandas dataframe
    """
    df = {}
    
    for checkm in checkms:
        key, value = read_individual_checkm(checkm)
        df[key] = value
    
    df = pd.DataFrame.from_dict(df, orient = "index")

    df.index.name = "id"
    return df

def parse_args(args):
    """Argument parsers
    """
    parser = argparse.ArgumentParser(description = "Summarise checkm outputs",
        usage = "python extract_checkm.py -i file1.tsv file2.tsv [...]")
    parser.add_argument("-i", "--input_checkms",
        required = True,
        nargs = "+",
        dest = "checkms",
        help = "List of checkm files")
    parser.add_argument("-o", "--output",
        default = None,
        dest = "output",
        help = "Output summary")
    if not args:
        parser.print_help(sys.stderr)
        sys.exit()
    return parser.parse_args(args)

def main():
    """Main function
    """
    args = sys.argv[1:]
    args = parse_args(args)

    logger = logging.getLogger("Parse checkm files")
    logger.setLevel(logging.INFO)
    sh = logging.StreamHandler()
    sh.setFormatter(logging.Formatter("%(asctime)s - %(message)s"))
    logger.addHandler(sh)

    df = checkms_to_df(args.checkms)

    if args.output is not None:
        df.to_csv(args.output)
    else:
        df.to_csv(sys.stdout)

if __name__ == "__main__":
    main()
