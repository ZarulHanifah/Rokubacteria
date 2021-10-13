checkpoint download_genomes:
	output:
		outdir = directory("results/download_genomes"),
		metadata = "results/download_genomes/assembly_summary.csv"
	conda:
		"../envs/download.yaml"
	log:
		"results/log/download_genome/log.log"
	params:
		taxa_name = config["taxa_name"],
		email_address = config["email_address"]
	shell:
		"""
		python scripts/download_genomes.py -e {params.email_address} \
						-t {params.taxa_name} \
						-o {output.outdir} &> {log}
		"""
