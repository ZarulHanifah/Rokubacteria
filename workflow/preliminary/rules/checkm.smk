rule checkm_genome:
    input:
        "input_folder/genomes/{id}.fasta"
    output:
        tmpout = temp(os.path.join(results_path, ".tmp/checkm/{id}/{id}.fasta")),
        out1 = os.path.join(results_path, "checkm/Bacteria_{id}/storage/bin_stats_ext.tsv")
    conda:
        "../envs/drep.yaml"
    params:
        tmpdir = "tmp/{id}",
        ext = "fasta",
        rank = "domain",
        taxon = "Bacteria",
    threads: 2
    log:
        os.path.join(results_path, "log/checkm/{id}.log")
    message:
        "Running checkm on sample {wildcards.id}"
    shell:
        """
        cp {input} {output.tmpout}
        
        tmpdir=$(dirname {output.tmpout})
        outdir=$(dirname $(dirname {output.out1}))

        checkm taxonomy_wf -t {threads} -x {params.ext} \
         {params.rank} \
         {params.taxon} \
         $tmpdir \
         $outdir &> {log}
        """

rule compile_checkm_summary:
    input:
        expand(rules.checkm_genome.output.out1, id = ids)
    output:
        os.path.join(results_path, "summary_checkm.csv")
    shell:
        """
        python src/extract_checkm.py -i {input} -o {output}
        """
