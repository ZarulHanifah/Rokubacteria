rule dram_annotate:
	input:
		bins = rules.drep_genomes.output,
		dram_config = config["dram_config"],
		gtdb_taxonomy = rules.gtdbtk_classify.output
	output:
		annot = "results/dram/annotation/annotations.tsv",
		rrna = "results/dram/annotation/rrnas.tsv",
		trna = "results/dram/annotation/trnas.tsv",
	conda:
		"../envs/dram.yaml"
	threads: 32
	log:
		"results/log/dram_annotate/log.log"
	shell:
		"""
		annot_dir=$(dirname {output.annot})
		rm -rf $annot_dir

		DRAM-setup.py import_config --config_loc {input.dram_config}
		
		DRAM.py annotate -i '{input.bins}/*fasta' \
				-o $annot_dir \
				--gtdb_taxonomy {input.gtdb_taxonomy} \
				--verbose &> {log}
		"""	

rule dram_distill:
	input:
		dram_config = config["dram_config"],
		annot = rules.dram_annotate.output.annot,
		rrna = rules.dram_annotate.output.rrna,
		trna = rules.dram_annotate.output.trna
	output:
		"results/dram/distill/product.html"
	conda:
		"../envs/dram.yaml"
	threads: 32
	log:
		"results/log/dram_distill/log.log"
	shell:
		"""
		distill_dir=$(dirname {output})

		DRAM-setup.py import_config --config_loc {input.dram_config}
		
		DRAM.py distill -i {input.annot} \
				-o $distill_dir \
				--trna_path {input.trna} \
				--rrna_path {input.rrna} &>> {log}
		"""	
