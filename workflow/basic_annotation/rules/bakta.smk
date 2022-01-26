rule bakta_annotation:
    input:
        fasta = "../../input_folder/genomes/{id}.fasta",
        db = config["bakta_db"]
    output:
        gff = os.path.join(config["out_path"], "bakta_out/{id}/{id}.gff3"),
        faa = os.path.join(config["out_path"], "bakta_out/{id}/{id}.faa")
    log:
        os.path.join(config["out_path"], "log/bakta_out/{id}.log")
    conda:
        "../envs/bakta.yaml"    
    threads: 2
    shell:
        """
        outdir=$(dirname {output.gff})
        locustag=$(echo {wildcards.id} | tr '[:lower:]' '[:upper:]' | awk '{{print substr($0,0,12)}}')

        bakta --db {input.db} \
            --output $outdir \
            --prefix {wildcards.id} \
            --locus-tag $locustag \
            --threads {threads} \
            {input.fasta} 2> {log}
        """

rule git_kofamscan:
    output:
        temp(directory("kofam_scan"))
    params:
        link = "https://github.com/takaram/kofam_scan.git"
    shell:
        """
        git clone {params.link}
        """

rule run_kofamscan:
    input:
        profile = config["kofamscan_profile"],
        kolist = config["kofamscan_kolist"],
        git_path = rules.git_kofamscan.output,
        faa = rules.bakta_annotation.output.faa
    output:
        faa = os.path.join(config["out_path"], "run_kofamscan/{id}/{id}.faa"),
        tmpdir = temp(directory(os.path.join(config["out_path"], "run_kofamscan/tmp{id}"))),
        txt = os.path.join(config["out_path"], "run_kofamscan/{id}/{id}.txt")
    log:
        os.path.join(config["out_path"], "log/run_kofamscan/{id}.log")
    conda:
        "../envs/kofam.yaml"	
    threads: 2
    params:
        format = "mapper"
    shell:
        """
        cat {input.faa} | sed "s/ .*//" > {output.faa}

        {input.git_path}/exec_annotation -o {output.txt} \
            -p {input.profile} \
            -k {input.kolist} \
            --cpu {threads} \
            -f {params.format} \
            --tmp-dir {output.tmpdir} \
            {output.faa} &> {log}
        """

rule keggdecoder:
    input:
        expand(rules.run_kofamscan.output.txt, id = ids)
    output:
        cat_maps = os.path.join(config["out_path"], "keggdecoder/all_maps.txt"),
        tsv = os.path.join(config["out_path"], f"keggdecoder/{taxa}_keggdecoder.tsv"),
    log:
        os.path.join(config["out_path"], "log/keggdecoder/log.log")
    conda:
        "../envs/kofam.yaml"	
    params:
        vizoption = "static"
    shell:
        """
        cat {input} > {output.cat_maps}

        KEGG-decoder -i {output.cat_maps} \
            -o {output.tsv} \
            -v {params.vizoption}
        """
