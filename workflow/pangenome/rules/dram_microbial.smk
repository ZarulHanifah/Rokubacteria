rule dram_microbial:
	input:
		bins = rules.drep_genomes.output,
		dram_config = config["dram_config"],
		gtdb_taxonomy = rules.gtdbtk_classify.output
	output:
		annot = "results/dram_out/annotation/annotations.tsv",
		distill = "results/dram_out/distill/product.html" 
	conda:
		"../envs/dram.yaml"
	threads: 32
	log:
		"results/log/dram_microbial/log.log"
	params:
		minlength = 1000
	shell:
		"""
		annot_dir=$(dirname {output.annot})
		distill_dir=$(dirname {output.distill})
		
		rm -rf $annot_dir

		DRAM-setup.py import_config --config_loc {input.dram_config}
		
		DRAM.py annotate -i '{input.bins}/*fasta' \
				-o $annot_dir \
				--gtdb_taxonomy {input.gtdb_taxonomy} \
				--verbose &> {log}

		DRAM.py distill -i {output.annot} \
				-o $distill_dir \
				--trna_path $annot_dir/trnas.tsv \
				--rrna_path $annot_dir/rrnas.tsv &>> {log}
		"""	
