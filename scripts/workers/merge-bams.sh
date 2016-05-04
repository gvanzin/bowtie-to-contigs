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

echo Started at $(date)

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

TMP_FILES=$(mktemp)

find $BAM_OUT_DIR -iname \*$SAMPLE\*.bam > $TMP_FILES

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" bams to merge

NEW_FILE="$SAMPLE".bam

if [[ ! -s $FINAL_BAM_DIR/$SAMPLE.bam ]]; then
    
    echo "deleting "$SAMPLE.bam" in case its a bad file"
    
    rm $FINAL_BAM_DIR/$SAMPLE.bam &> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "Deleted bam and making new one"
    else
        echo "BAM isn't there and that's ok"
    fi

    echo Merging multiple bams into "$SAMPLE".bam
    samtools merge -@ 12 -b $TMP_FILES $FINAL_BAM_DIR/$SAMPLE.bam
    
    echo "Renaming to "$SAMPLE".raw.bam"
    mv $FINAL_BAM_DIR/$SAMPLE.bam $FINAL_BAM_DIR/$SAMPLE.raw.bam
else
    echo $SAMPLE already done
fi

echo Done at $(date)
