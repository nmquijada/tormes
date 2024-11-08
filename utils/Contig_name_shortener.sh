#!/bin/bash
# Purpose: Prokka has a contig name character limit that sometimes spades exceeds.
# This script will rename spades fasta file contig names to a length that Prokka will accept
# usage: script.sh sequences.fasta > newsequence.fasta

while read line ; do
    if [ ${line:0:1} == ">" ] ; then
        IFS='\.' read -a header <<< "$line"
    	echo -e "${header[0]}"
    else
        echo -e "$line"
    fi
done < $1
