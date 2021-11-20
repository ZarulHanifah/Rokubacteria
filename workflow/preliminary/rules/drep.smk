rule drep_genomes:
    input:
        expand("input_folder/genomes/{id}.fasta", id = ids)
    output:
        directory(os.path.join(results_path, "drep/dereplicated_genomes"))
    conda:
        "../envs/drep.yaml"
    threads: 16
    log:
        os.path.join(results_path, "log/drep_genomes/log.log")
    message:
        "Dereplicating genomes"
    shell:
        """
        outdir=$(dirname {output})

        dRep check_dependencies &> {log}
        dRep dereplicate $outdir -p {threads} -g {input} &>> {log}
        """
