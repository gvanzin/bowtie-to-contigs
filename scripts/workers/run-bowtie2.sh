#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=12:mem=23gb
#PBS -l pvmem=46gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $PBS_O_WORKDIR
CONFIG="$PRJ_DIR/scripts/config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo MIssing config \"$CONFIG\"
    exit 12385
fi

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

TMP_FILES=$(mktemp)

get_lines $FILES_TO_PROCESS $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

while read FASTA; do
    IN=$SPLIT_FA_DIR/$FASTA
   
    OUT_DIR=$BOWTIE2_OUT_DIR/$(dirname $FASTA)

    OUT=$OUT_DIR/$(basename $FASTA ".fa").sam

    if [[ ! -d "$OUT_DIR" ]]; then
        mkdir -p "$OUT_DIR"
    fi
    
    if [[ -e $OUT ]]; then
        echo "Sam file already exists, skipping..."
        continue
    else
        echo "Processing $FASTA"
    fi

    bowtie2 -p 12 \
        --very-sensitive-local \
        -f \
        --no-unal \
        -x $BOWTIE2_DB \
        -U $IN \
        -S $OUT

done < "$TMP_FILES"



