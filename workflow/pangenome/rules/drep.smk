def evaluate_download_checkpoint_get_outdir(*wildcards):
	checkpoint_outdir = checkpoints.download_genomes.get().output.outdir
	return checkpoint_outdir

def evaluate_download_checkpoint_glob_samples(*w):
	checkpoint_outdir = evaluate_download_checkpoint_get_outdir(*w)
	samples, = glob_wildcards(os.path.join(checkpoint_outdir, "{sample}.fasta"))
	return samples

def input_drep_genomes(*w):
	checkpoint_outdir = evaluate_download_checkpoint_get_outdir(*w)
	return [os.path.join(checkpoint_outdir, sample + ".fasta") for sample in evaluate_download_checkpoint_glob_samples(*w)]

rule drep_genomes:
	input:
		input_drep_genomes	
	output:
		directory("results/drep/dereplicated_genomes")
	conda:
		"../envs/drep.yaml"
	threads: 16
	log:
		"results/log/drep_genomes/log.log"
	shell:
		"""
		outdir=$(dirname {output})

		dRep check_dependencies
		dRep dereplicate $outdir -p {threads} -g {input} &> {log}
		"""
