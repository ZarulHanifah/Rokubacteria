snakemake -j 30 -k --use-conda \
    --cluster-config config/cluster.yaml \
    --cluster "sbatch \
        --cpus-per-task={threads} \
        --output={cluster.output} \
        --error={cluster.error} \
        --job-name={cluster.jobname} \
        --mail-user=muhammad.zarulhanifah@monash.edu \
        {cluster.etc}"
