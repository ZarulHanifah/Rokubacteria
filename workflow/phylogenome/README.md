# phylogenome workflow

![Overall workflow](src/graph_rulegraph.png)

### Description of workflow
- Construction of phylogenomic tree using gtotree
- Count pairwise ANI
	- Draw matrix
- Construction of 16S tree
	- Include sequences from SILVA database
- Count 16S pairwise similarity
	- Draw matrix

### Notes
- Will include genomes from Methylomirabilales order as outgroup. Accession IDs of :
	| Accession   | Taxonomic description      |
	|-------------|----------------------------|
	| ASM304403v1 | Methylomirabilis limnetica |
	| ASM9116v1   | Methylomirabilis oxyfera   |
