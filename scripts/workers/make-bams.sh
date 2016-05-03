#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=12:mem=23gb:pcmem=2gb
#PBS -l pvmem=46gb
#PBS -l walltime=3:00:00
#PBS -l cput=36:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

if [ -n "$PBS_O_WORKDIR" ]; then
    cd $PBS_O_WORKDIR
fi

set -u

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

while read FILE; do

    NEW_FILE=$(basename $FILE ".fastq.sam")

    if [[ ! -s $BAM_OUT_DIR/$NEW_FILE.bam ]]; then
        echo Converting $FILE using reference $CONTIGS
        samtools view -@ 12 -bT $CONTIGS $FILE > $FILE.temp
        echo Sorting $FILE
        samtools sort -@ 12 $FILE.temp > $BAM_OUT_DIR/$NEW_FILE.bam
        echo Removing $FILE.temp
        rm $FILE.temp
    else
        echo $FILE already done
    fi
done < "$TMP_FILES"

