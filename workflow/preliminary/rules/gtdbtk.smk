rule gtdbtk_classify:
    input:
        indir = expand("input_folder/genomes/{id}.fasta", id = ids),
        gtdbtk_db = config["gtdbtk_db"]
    output:
        os.path.join(results_path, "gtdbtk_out/classify/gtdbtk.bac120.summary.tsv")
    conda:
        "../envs/gtdbtk.yaml"
    threads: 24
    log:
        os.path.join(results_path, "log/gtdbtk_classify/log.log")
    params:
        ext = "fasta"
    message:
        "Assigning GTDB taxonomy"
    shell:
        """
        export GTDBTK_DATA_PATH={input.gtdbtk_db}

        indir=$(dirname {input.indir[0]})
        outdir=$(dirname $(dirname {output}))

        gtdbtk classify_wf --genome_dir $indir \
         --cpus {threads} \
         --extension {params.ext} \
         --out_dir $outdir &> {log}
        """
