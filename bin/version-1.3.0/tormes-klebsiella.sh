#! /bin/bash

TORMESVERSION="1.3.0"
VERSION="1.3.0"

if [ $# == 0 ]; then
cat << EOF

This is tormes-klebsiella version $VERSION, deviced for working with TORMES version $TORMESVERSION
This script perform special analysis when the option -g/--genera Klebsiella is enabled
WARNING: positional arguments are required!

usage: $0 <tormes path> <working directory> <tormes config file> <CPUs>

EOF

exit 1
fi

#VARIABLES
CONFIG=$3
CPUS=$4
OUTWD=$2
SAMPLE="$(<$OUTWD/list.tmp)"
TAB="$(printf '\t')"
TORMESDIR=$1

#DEPENDENCIES
ABRICATE="$( grep -w "^ABRICATE\s" $CONFIG | cut -f 2 -d "$TAB" )"
BLASTBINS="$( grep -w "^BLAST-2\.6_or_later-BINARIES\s" $CONFIG | cut -f 2 -d "$TAB" )"
KAPTIVE="$( grep -w "^KAPTIVE\s" $CONFIG | cut -f 2 -d "$TAB" )"
PARALLEL="$( grep -w "^PARALLEL\s" $CONFIG | cut -f 2 -d "$TAB" )"
POINTFINDER="$( grep -w "^POINTFINDER\s" $CONFIG | cut -f 2 -d "$TAB" )"
POINTFINDERDB="$( grep -w "^POINTFINDER-DATABASE\s" $CONFIG | cut -f 2 -d "$TAB" )"


## KLEBSIELLA ANALYSIS

# Locus typing

	echo -e "Surface polysaccharide locus typing started at: \c" >> $OUTWD/tormes.log
  date +"%Y-%m-%d %H:%M" >> $OUTWD/tormes.log
	echo -e "* Kaptive, [Wyres *et al*., 2016](https://www.microbiologyresearch.org/content/journal/mgen/10.1099/mgen.0.000102)" >> $OUTWD/citations.txt
	mkdir -p $OUTWD/locus-typing
	python $KAPTIVE -a $OUTWD/genomes/*.fasta -k $TORMESDIR/../db/kaptive/Klebsiella_k_locus_primary_reference.gbk -o $OUTWD/locus-typing/K-locus -t $CPUS --no_json --no_seq_out
	if [ ! -s $OUTWD/locus-typing/K-locus_table.txt ]; then
		echo "WARNING: K-locus typing was not performed" >> $OUTWD/tormes.log
	fi
	python $KAPTIVE -a $OUTWD/genomes/*.fasta -k $TORMESDIR/../db/kaptive/Klebsiella_o_locus_primary_reference.gbk -o $OUTWD/locus-typing/O-locus -t $CPUS --no_json --no_seq_out
	if [ ! -s $OUTWD/locus-typing/O-locus_table.txt ]; then
		echo "WARNING: O-locus typing was not performed" >> $OUTWD/tormes.log
	fi

# PlasmidFinder
	echo -e "\nPlasmid search started at: \c" >> $OUTWD/tormes.log
	date +"%Y-%m-%d %H:%M" >> $OUTWD/tormes.log
	echo -e "* PlasmidFinder database, [A. Carattoli *et al*., 2014](https://www.ncbi.nlm.nih.gov/pubmed/24777092)" >> $OUTWD/citations.txt
	mkdir -p $OUTWD/plasmids
	$PARALLEL -j $CPUS -a $OUTWD/list.tmp --results $OUTWD/plasmids/{}\_plasmids.tab $ABRICATE $OUTWD/genomes/{}.fasta --db plasmidfinder --nopath
	rm -f $OUTWD/plasmids/*err $OUTWD/plasmids/*seq
	for i in $SAMPLE; do
		sed -i 's/.fasta//' $OUTWD/plasmids/${i}_plasmids.tab
	done

# PointFinder
	echo -e "\nPoint mutation search started at: \c" >> $OUTWD/tormes.log
	date +"%Y-%m-%d %H:%M" >> $OUTWD/tormes.log
	echo -e "* PointFinder, [E. Zankari *et al*., 2017](https://www.ncbi.nlm.nih.gov/pubmed/29091202)" >> $OUTWD/citations.txt
	mkdir -p $OUTWD/point_mutations
	for i in $SAMPLE; do
		mkdir -p $OUTWD/point_mutations/${i}
		python $POINTFINDER -i $OUTWD/genomes/${i}.fasta -p $POINTFINDERDB -m blastn -m_p $BLASTBINS/blastn -s klebsiella -o $OUTWD/point_mutations/${i}
		rm -rf $OUTWD/point_mutations/${i}/tmp
		mv -f $OUTWD/point_mutations/${i}/*_blastn_results.tsv $OUTWD/point_mutations/${i}/${i}_PointFinder_results.txt
		if [ -s $OUTWD/point_mutations/${i}/${i}_PointFinder_results.txt ]; then
			echo "" >> $OUTWD/point_mutations/${i}/${i}_PointFinder_results.txt
		else
			echo "WARNING: Point mutations analysis for ${i} was not performed" >> $OUTWD/tormes.log
		fi
	done

## Cleaning the house
rm -rf $OUTWD/genomes/*fasta.ndb $OUTWD/genomes/*fasta.not $OUTWD/genomes/*fasta.ntf $OUTWD/genomes/*fasta.nto
