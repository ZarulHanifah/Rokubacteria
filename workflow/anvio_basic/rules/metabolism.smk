rule run_anvio_estimate_metabolism:
    input:
        rules.gen_anvio_contig_db.output.contigdb
    output:
        os.path.join(config["out_path"], "metabolism/{id}_modules.txt")
    threads:
        4
    log:
        os.path.join(config["out_path"], "log/anvio_estimate_metabolism/{id}.log")
    shell:
        """
        prefix=$(echo {output} | sed "s/_modules\.txt//")
        anvi-estimate-metabolism -c {input} -O $prefix &> {log}
        """

rule summarize_anvio_metabolism:
    input:
        expand(rules.run_anvio_estimate_metabolism.output, id = ids)
    output:
        os.path.join(config["out_path"], "figures/anvio_kofam_pathway_summary.png")
    conda:
        "../envs/plotting.yaml"
    shell:
        """
        python src/summary_plot_anvio_metabolism.py -i $(dirname {input[0]}) -o {output}
        """
