rule checkm_genome:
    input:
        "input_folder/genomes/{id}.fasta"
    output:
        out1 = "results/checkm/Bacteria_{id}/storage/bin_stats_ext.tsv"
    conda:
        "../envs/drep.yaml"
    params:
        tmpdir = "tmp/{id}",
        ext = "fasta",
        rank = "domain",
        taxon = "Bacteria",
    threads: 2
    log:
        "results/log/checkm/{id}.log"
    message:
        "Running checkm on sample {wildcards.id}"
    shell:
        """
        cp {input} {output.tmpout}
        
        tmpdir=$(dirname {input})
        outdir=$(dirname $(dirname {output}))

        checkm taxonomy_wf -t {threads} -x {params.ext} \
         {params.rank} \
         {params.taxon} \
         $tmpdir \
         $outdir &> {log}
        """
