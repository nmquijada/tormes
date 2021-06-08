#! /bin/bash

TORMESVERSION="1.3.0"
VERSION="1.3.0"

usage() {
cat << EOF

This is tormes-custom-genes-db version $VERSION, deviced for working with TORMES version $TORMESVERSION
This script
WARNING: positional arguments are required!

usage: $0 <tormes path> <working directory> <tormes config file> <CPUs> <genes db list> <gene min ID %> <gene min cov %>

EOF
}


if [ $# == 0 ]; then
  usage
  exit 1
fi

#VARIABLES
CONFIG=$3
CPUS=$4
OUTWD=$2
SAMPLE="$(<$OUTWD/list.tmp)"
TAB="$(printf '\t')"
TORMESDIR=$1
GENESDBLIST=$5
GENEMINID=$6
GENEMINCOV=$7


#DEPENDENCIES
ABRICATE="$( grep -w "^ABRICATE\s" $CONFIG | cut -f 2 -d "$TAB" )"
PARALLEL="$( grep -w "^PARALLEL\s" $CONFIG | cut -f 2 -d "$TAB" )"

mkdir ${OUTWD}/custom_genes_db
for i in $(<${GENESDBLIST}); do
  mkdir ${OUTWD}/custom_genes_db/${i}
  $PARALLEL -j $CPUS -a $OUTWD/list.tmp --results $OUTWD/custom_genes_db/${i}/{}\_${i}.tab $ABRICATE $OUTWD/genomes/{}.fasta --db $i --minid $GENEMINID --mincov $GENEMINCOV --nopath
  rm -f $OUTWD/custom_genes_db/${i}/*err $OUTWD/custom_genes_db/${i}/*seq
  for j in $SAMPLE; do
		sed -i 's/.fasta//' $OUTWD/custom_genes_db/${i}/${j}_${i}.tab
	done
done
