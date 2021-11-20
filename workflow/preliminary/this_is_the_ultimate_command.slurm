snakemake -j 30 -k --use-conda \
    --cluster-config config/cluster.yaml \
    --conda-frontend mamba \
    --cluster "sbatch \
        --cpus-per-task={threads} \
        --output={cluster.output} \
        --error={cluster.error} \
        --job-name={cluster.jobname} \
        --mail-user=sanlee9965@gmail.com \
        {cluster.etc}"
