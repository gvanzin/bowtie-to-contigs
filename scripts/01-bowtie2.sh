#!/usr/bin/env bash

#
# This script is intended to use taxoner to map fastas to a metagenome 
#

set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

if [[ -d "$BOWTIE2_OUT_DIR" ]]; then
    echo "Continuing where you left off..."
else
    mkdir -p "$BOWTIE2_OUT_DIR"
fi

cd "$SPLIT_FA_DIR"

export FILES_LIST="$PRJ_DIR/split-files"

echo "Finding fasta's"

find . -type f -iname \*.fa | sed "s/^\.\///" > $FILES_LIST 

echo "Checking if already processed"

if [ -e $PRJ_DIR/files-to-process ]; then
    rm $PRJ_DIR/files-to-process
fi

export FILES_TO_PROCESS="$PRJ_DIR/files-to-process"

while read FASTA; do
 
    OUT_DIR=$BOWTIE2_OUT_DIR/$(dirname $FASTA)

    OUT=$OUT_DIR/$(basename $FASTA ".fa").sam

    if [[ -e $OUT ]]; then
        continue
    else
        echo $FASTA >> $FILES_TO_PROCESS
    fi

done < $FILES_LIST

NUM_FILES=$(lc $FILES_TO_PROCESS)

echo \"Found $NUM_FILES to process\"

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -v PRJ_DIR,STEP_SIZE,WORKER_DIR,FILES_TO_PROCESS,SPLIT_FA_DIR,BOWTIE2_OUT_DIR -N bowtie2 -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-bowtie2.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: sholders back, chin tucked in, tongue on roof of mouth, deep belly breaths.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
