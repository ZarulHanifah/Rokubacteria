rule bakta_annotation:
	input:
		fasta = "../../input_folder/genomes/{id}.fasta",
		db = config["bakta_db"]
	output:
		os.path.join(config["out_path"], "bakta_out/{id}/{id}.gff3")
	log:
		os.path.join(config["out_path"], "log/bakta_out/{id}.log")
	conda:
		"../envs/bakta.yaml"	
	threads: 2
	shell:
		"""
		outdir=$(dirname {output})

		bakta --db {input.db} \
			--output $outdir \
			--prefix {wildcards.id} \
			--verbose \
			{input.fasta} 2> {log}
		"""
