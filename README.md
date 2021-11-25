# Rokubacteria (六)

### Introduction
Rokubacteria is a bacterial phylum that is found in diverse environment such as:
- Groundwater (Hug et al., 2015)
- Soil (Becraft et al., 2017; Crits-Cristoph et al., 2018)
- Hydrothermal sediments (Zhou et al., 2020)

It's hallmark metabolic activities include:
- Secondary metabolite biosynthesis
- Nitrite-dependent denitrification coupled to methanotrophy (check)

### Aim
To better the understand the ecology and diversity of Rokubacteria, we attempt to apply metapangenomics and phylogenomics using publically-available metadata.

### Disclaimer
This analysis was meant as a practice. In the case if we are considering of publishing results using these data, we will inform the data providers beforehand.

### The flow of the analysis
- [Obtain genomes and metadata](workflow/preliminary)
- [Phylogenomics analysis](workflow/phylogenome)
- [Pangenomics + metabolism estimation analysis using anvio](workflow/pangenome)
- [Metapangenome analysis using anvio](workflow/metapangenome)
	- This will require a number of metagenome data

* some ideas
	- find codon/amino acid bias
	- explore unknown genes using agnostos
	- find defense genes
	- find bacterial microcompartment genes
	- find biosynthetic gene clusters

### TODO
- Attempt genome annotation using bakta
- Try alternative genetic codes
	- Use prodigal for gene calling
	- Using genetic code 4, 11 and 15
	- Write script to count gene density: calculate sum length of genes over total contig length
- Try detecting bacterial defense mechanisms
	- Might not be the best on MAGs, but we'll see
- Compare anvio-estimate-metabolism with DRAM output

### Citations
Becraft, E. D., Woyke, T., Jarett, J., Ivanova, N., Godoy-Vitorino, F., Poulton, N., Brown, J. M., Brown, J., Lau, M. C. Y., Onstott, T., Eisen, J. A., Moser, D., & Stepanauskas, R. (2017). Rokubacteria: Genomic Giants among the Uncultured Bacterial Phyla  . In Frontiers in Microbiology  (Vol. 8, p. 2264). https://www.frontiersin.org/article/10.3389/fmicb.2017.02264

Crits-Christoph A, Diamond S, Butterfield CN, Thomas BC, Banfield JF. 2018.
Novel soil bacteria possess diverse genes for secondary metabolite
biosynthesis. Nature 558:440–444. https://10.1038/s41586-018-0207-y

Hug, L.A., Thomas, B.C., Sharon, I., Brown, C.T., Sharma, R., Hettich, R.L., Wilkins, M.J., Williams, K.H., Singh, A. and Banfield, J.F. (2016), N- and C-cycling organisms in the subsurface. Environ Microbiol, 18: 159-173. https://doi.org/10.1111/1462-2920.12930

Zhou Z, Liu Y, Xu W, Pan J, Luo ZH, Li M. Genome- and Community-Level Interaction Insights into Carbon Utilization and Element Cycling Functions of Hydrothermarchaeota in Hydrothermal Sediment. mSystems. 2020 Jan 7;5(1):e00795-19. https://10.1128/mSystems.00795-19
