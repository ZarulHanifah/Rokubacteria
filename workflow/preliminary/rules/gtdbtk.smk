rule gtdbtk_classify:
	input:
		drep = rules.drep_genomes.output,
		gtdbtk_db = config["gtdbtk_db"]
	output:
		"results/gtdbtk_out/classify/gtdbtk.bac120.summary.tsv"
	conda:
		"../envs/gtdbtk.yaml"
	threads: 24
	log:
		"results/log/gtdbtk_classify/log.log"
	params:
		ext = "fasta"
	shell:
		"""
		export GTDBTK_DATA_PATH={input.gtdbtk_db}
		
		outdir=$(dirname $(dirname {output}))

		gtdbtk classify_wf --genome_dir {input.drep} \
		 --cpus {threads} \
		 --extension {params.ext} \
		 --out_dir $outdir &> {log}
		"""
