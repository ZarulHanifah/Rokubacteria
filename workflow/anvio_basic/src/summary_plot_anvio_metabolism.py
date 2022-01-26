import sys
import os
import pandas as pd
import numpy as np
import re
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.ticker as mticker
import matplotlib.gridspec as gridspec
import argparse

plt.style.use("ggplot")

color_map = {
    0: "Greens",
    1: "Blues",
    2: "Purples",
    3: "Reds",
    4: "Oranges"
}

def subfunc2(df):
    name = df["genome_name"].tolist()[0]

    df = df.groupby(["module_subcategory"], as_index = False).max()
    df.set_index("module_subcategory", inplace = True)
    df = pd.DataFrame(df["module_completeness"])
    df.columns = [name]
    df.fillna(0, inplace = True)
    return df


def gen_cat_to_subcat(input_dir):
    cts = {}
    for root, dirs, files  in os.walk(input_dir, topdown = False):
        for mfile in files:
            df = pd.read_csv(os.path.join(root, mfile), sep = "\t")

            cat_to_subcat = df.loc[:, ["module_category", "module_subcategory"]]\
                .set_index("module_subcategory")\
                .to_dict()["module_category"]
            for c, s in cat_to_subcat.items():
                if c not in cts:
                    cts[c] = s
    return cts

def generate_main_df(input_dir):
    cts = gen_cat_to_subcat(input_dir)
    l_df = []
    for root, dirs, files  in os.walk(input_dir, topdown = False):
        for idx, mfile in enumerate(files):
            path = os.path.join(root, mfile)

            df = pd.read_csv(path, sep = "\t")
            acc = re.sub("_modules.txt", "", mfile)
            df["genome_name"] = [acc] * df.shape[0]
            
            df = subfunc2(df)
            l_df.append(df)
    l_df = pd.concat(l_df, axis = 1)
    l_df["module_category"] = l_df.index.map(cts)
    l_df.sort_values("module_category", inplace = True)

    return l_df

def generate_figure(input_dir, out_fig):
    main_df = generate_main_df(input_dir)

    cats = main_df["module_category"].value_counts().index.tolist()
    cats_weight = list(main_df["module_category"].value_counts())

    fig, ax = plt.subplots(nrows = len(main_df["module_category"].unique()),
                           figsize = (9, 14), dpi = 300,
                           sharex = True, gridspec_kw={'height_ratios': cats_weight})
    
    for row, cat in enumerate(cats):
        subdf = main_df.loc[main_df["module_category"] == cat, main_df.columns != "module_category"]
    #     subdf = subdf.iloc[::-1]
        subdf = subdf.pipe(lambda subdf: subdf.loc[subdf.sum(axis = "columns").sort_values(ascending=True).index, :])
        color = color_map[row%len(color_map)]
        
        ax[row].pcolor(subdf, cmap = color, linewidths=1, edgecolor='white', snap=True, facecolor=None)
        
        yaxticks = subdf.index.tolist()
        ax[row].set_yticks([x + 0.5 for x in list(range(len(yaxticks)))])
        ax[row].yaxis.set_ticklabels(ticklabels = yaxticks)
        
        if row != len(cats) - 1:
            ax[row].get_xaxis().set_visible(False)
        else:
            xaxticks = main_df.columns.tolist()
            xaxticks = [x for x in xaxticks if "GCA" in x]
            ax[row].set_xticks([x + 1.5  for x in list(range(len(xaxticks)))])
            ax[row].set_xticklabels(xaxticks, rotation = 90, ha = "right")
    
        ax[row].set_ylabel(cat,  rotation = 0, ha = "left", position = (0, 1))
        
    plt.subplots_adjust(wspace=0, hspace=0.8)
    plt.tight_layout()
    plt.savefig(out_fig)

p = argparse.ArgumentParser()
p.add_argument("-i", "--input_dir", type = str,
               help = "input directory containing all anvio metabolism files")
p.add_argument("-o", "--out_fig", type = str,
               help = "output figure")
if len(sys.argv) < 2:
    p.print_help()
    sys.exit(1)
args = p.parse_args()

if __name__ == '__main__':
    generate_figure(args.input_dir, args.out_fig)
