rule gen_anvio_contig_db:
    input:
        config["raw_genome_path"]
    output:
        contig_tmp = temp(os.path.join(config["out_path"], ".tmp/{id}.fasta")),
        contigdb = os.path.join(config["out_path"], "anvio_contig_db/{id}.db")
    threads: 4
    log:
        os.path.join(config["out_path"], "log/gen_anvio_contig_db/{id}.log")
    params:
        seqtype = "NT"
    shell:
        """
        anvi-script-reformat-fasta {input} -o {output.contig_tmp} --simplify-names --seq-type {params.seqtype}
        anvi-gen-contigs-database -f {output.contig_tmp} -o {output.contigdb} &> {log}
        anvi-run-hmms -c {output.contigdb} -T {threads} --also-scan-trnas &>> {log}
        anvi-run-ncbi-cogs  -c {output.contigdb} -T {threads} &>> {log}
        anvi-run-kegg-kofams -c {output.contigdb} -T {threads} &>> {log}
        """

rule generate_external_genomes:
    input:
        expand(rules.gen_anvio_contig_db.output.contigdb, id = ids)
    output:
        os.path.join(config["out_path"], "external_genome.list")
    shell:
        """
        echo "name\tcontigs_db_path" > {output}

        for gen in {input}; do
            n=$(basename $gen ".db")
            echo "$n\t$gen" >> {output}
        done
        """

rule gen_anvio_genome_storage:
    input:
        contig_dbs = expand(rules.gen_anvio_contig_db.output.contigdb, id = ids),
        genome_list = rules.generate_external_genomes.output
    output:
        genome_storage = os.path.join(config["out_path"],"{}-GENOMES.db".format(config["prefix"]))
    shell:
        """
        anvi-gen-genomes-storage -e {input.genome_list} -o {output.genome_storage}
        """

rule run_anvio_pangenome:
    input:
        genome_storage = rules.gen_anvio_genome_storage.output.genome_storage,
        tree = config["phylogenome_tree"],
        external_genomes = rules.generate_external_genomes.output
    output:
        pan = os.path.join(config["out_path"], "{}/{}-PAN.db".format(config["prefix"], config["prefix"])),
        tree_labels = temp(os.path.join(config["out_path"], ".tmp/tree_labels.txt")),
        ani = directory(os.path.join(config["out_path"], "ANI"))
    threads: 8
    log:
        os.path.join(config["out_path"], "log/run_anvio_pangenome.log")
    params:
        min_occurence = 2,
        ani_program = "pyANI",
    shell:
        """
        main_name=$(basename $(dirname {output.pan}))
        
        rm -rf $main_name

        anvi-pan-genome -g {input.genome_storage} -n $main_name --output-dir $main_name --num-threads {threads} --min-occurrence {params.min_occurence} --enforce-hierarchical-clustering &> {log}
        anvi-compute-genome-similarity -e {input.external_genomes} -o {output.ani} -p $main_name"/"$main_name"-PAN.db" -T {threads} --program {params.ani_program} &>> {log}
                echo -e "item_name\tdata_type\tdata_value" > {output.tree_labels}
        echo -e "Tree\tnewick\t`cat {input.tree}`" >> {output.tree_labels}
        
        anvi-import-misc-data {output.tree_labels} -p $main_name"/"$main_name"-PAN.db" -t layer_orders --just-do-it &>> {log}
        
        """
