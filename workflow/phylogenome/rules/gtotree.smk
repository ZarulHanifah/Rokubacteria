rule build_alignment:
	input:
		expand("../../input_folder/genomes/{id}.fasta", id = ids)
	output:
		tmp_list = os.path.join(results_path, ".tmp/genome_list.txt"),
		aln = os.path.join(results_path, "gtotree_alignment/Aligned_SCGs_mod_names.faa"),
		tre = os.path.join(results_path, "gtotree_alignment/iqtree_out.contree")
	conda:
		"../envs/gtotree.yaml"
	threads: 8
	params:
		hmm_set = "Bacteria"
	log:
		os.path.join(results_path, "log/gtotree_alignment.log")
	message:
		"Constructing sequence alignment"
	shell:
		"""
		out_prefix=$(dirname {output.aln})

		find $(dirname {input[0]}) -type f | grep "fasta\|fna" > {output.tmp_list}

		rm -rf $out_prefix

		GToTree -N \
				-f {output.tmp_list} \
				-H {params.hmm_set} \
		 		-j {threads} \
		 		-o $out_prefix &> {log}
		"""


rule build_phylogenomic_tree:
	input:
		rules.build_alignment.output.aln
	output:
		os.path.join(results_path, "phylogenome_tree/iqtree_out.contree")
	conda:
		"../envs/gtotree.yaml"
	threads: 8
	params:
		mode = "MFP",
		bootstrap = 1000
	log:
		os.path.join(results_path, "log/phylogenome_tree.log")
	message:
		"Constructing phylogenomic tree"
	shell:
		"""
		out_prefix=$(dirname {output})
		
		iqtree -s {input} \
				-m {params.mode} \
				-bb {params.bootstrap} \
				-pre $out_prefix"/iqtree_out" &> {log}
		"""


