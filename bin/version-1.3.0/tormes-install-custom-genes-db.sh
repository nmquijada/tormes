#! /bin/bash

TORMESVERSION="1.3.0"
VERSION="1.3.0"

TORMES=$(which tormes)
while [ -h "$TORMES" ]; do # resolve $TORMES until the file is no longer a symlink
  TORMESDIR="$( cd -P "$( dirname "$0" )" && pwd )"
  TORMES="$(readlink "$TORMES")"
  [[ $TORMES != /* ]] && TORMES="$TORMESDIR/$TORMES" # if $TORMES is a symlink, resolve it relative to the path where the symlink file was located
done
TORMESDIR="$( cd -P "$( dirname "$TORMES" )" && pwd )"
DBPATH=$TORMESDIR/../db/

usage() {
cat << EOF

This is tormes-install-custom-genes-db.sh version $VERSION, deviced for working with TORMES version $TORMESVERSION

Make sure that your TORMES environment is activated.

usage: $0 -i <fasta file> -d <name of the database>

TORMES uses the software ABRicate (T. Seemann, https://github.com/tseemann/abricate) for nucleotide gene searches. This software requires an specific formatting the FASTA headers to work.
Please refer to TORMES documentation (https://github.com/nmquijada/tormes/wiki) for a detailed explanation on how to proceed.

Briefly, if you want a database called MYDB and you have your genes in a FASTA file called "mydb-genes.fasta":
  - Each fasta header must start with ">MYDB"
  - Gene name, gene accession and further descriptions can be included in the fasta headers and will appear in the results.
  - Such information must be separated by 3 '~' (~~~). Here there is an example:

>MYDB~~~gene_ID~~~gene_accession~~~Further descriptions that can include spaces

Once your FASTA file has been formatted accordingly, just run:

$0 -i mydb-genes.fasta -d MYDB

Your database might be ready to be used in TORMES.

You can check the installed databases by typing: $TORMESDIR/abricate --list

EOF
}


if [ $# == 0 ]; then
  usage
  exit 1
fi

## OPTIONS
POSITIONAL=()
while [[ $# -gt 0 ]]
do
ARGS="$1"

case $ARGS in
  -i)
    INPUT="$2"
    shift 2
    ;;
  -d)
    DBNAME="$2"
    shift 2
    ;;
  -?*)
    echo -e "\nERROR: unknown option: $1 \n"
  	usage
  	exit 1
  	;;
  *)
  	echo -e "\nERROR: unknown option: $1 \n"
    usage
    exit 1
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# CHECK OBLIGATORY VARIABLES
if [ -z "$INPUT" ] || [ -z "$DBNAME" ]; then
	echo ""
	if [ -z "$INPUT" ]; then
           echo 'ERROR: "-i" option is needed!'
        fi
	if [ -z "$DBNAME" ]; then
	   echo 'ERROR: "-d" option is needed!'
	fi
	echo ""
	exit 1
fi

if [ -d "$DBPATH/$DBNAME" ]; then
  echo -e "\nERROR: $DBNAME already exists! Please check"
  echo -e 'type "abricate --list" to list the available databases'
	exit 1
fi

# use any fasta validator? such as: https://github.com/linsalrob/fasta_validator

mkdir $DBPATH/$DBNAME
cp $INPUT ${DBPATH}/${DBNAME}/sequences
makeblastdb -in ${DBPATH}/${DBNAME}/sequences -title $DBNAME -dbtype nucl -hash_index
