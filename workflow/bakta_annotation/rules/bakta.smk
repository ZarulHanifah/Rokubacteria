rule bakta_annotation:
	input:
		fasta = "../../input_folder/genomes/{id}.fasta",
		db = config["bakta_db"]
	output:
		os.path.join(config["out_path"], "bakta_out/{id}")
	log:
		os.path.join(config["out_path"], "log/bakta_out/{id}")
	conda:
		"../envs/bakta.yaml"	
	threads: 2
	shell:
		"""
		outdir=$(echo {output} | 
		bakta --db {input.db} \
			--verbose \
			--output $outdir \
			{input.fasta}
		"""
