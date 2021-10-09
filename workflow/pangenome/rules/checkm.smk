rule pre_checkm:
	input:
		"../../input_folder/genomes/{sample}.fasta"
	output:
		"results/pre_checkm/{sample}.txt"
	shell:
		"""
		command1 -i {input} -o {output}
		"""
rule checkm:
	input:
		rules.pre_checkm.output
	output:
		"results/checkm/{sample}/summary.csv"
	shell:
		"""
		command1 -i {input} -o {output}
		"""
