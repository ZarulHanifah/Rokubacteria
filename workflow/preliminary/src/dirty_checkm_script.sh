
threads=2
ext=fasta
rank=domain
taxon=Bacteria

if [ -z $1 ]
then
	echo "Please specify input genome folder"
    exit
fi


for i in $(ls $1 | grep "\.fasta"); do
	name=$(echo $i | sed "s/\.fasta//")
	
	fpath=$1"/"$i
    tmpdir="checkm_"$1"/.tmp_"$name
    outdir="checkm_"$1"/Bacteria_"$name
    log="log/checkm_"$1"/"$name".log"

    mkdir -p $(dirname $log ) &> /dev/null

    if [ ! -d $outdir ]; then
        mkdir -p $tmpdir &> /dev/null
        cp $fpath $tmpdir &> /dev/null

    	checkm taxonomy_wf -t $threads -x $ext \
             $rank \
             $taxon \
             $tmpdir \
             $outdir &> $log
        echo
    fi
    rm -rf $tmpdir
done | tqdm --total $(ls $1 | grep "\.fasta" | wc -l)