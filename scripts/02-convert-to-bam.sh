#!/usr/bin/env bash

#
# This script is intended to make bams from sams and then sort
#

unset module
set -u
source ./config.sh
export CWD="$PWD"

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

FILE_LIST="$PRJ_DIR/sam_files"

find $BOWTIE2_OUT_DIR -iname \*.sam > $FILE_LIST

export NUM_FILES=$(lc $FILE_LIST)

echo \"Found $NUM_FILES to make bams from\"
echo \"Splitting them up in batches of "$STEP_SIZE"\"

echo Making output dir...
if [ ! -d $BAM_OUT_DIR ]; then
    mkdir -p $BAM_OUT_DIR
fi

echo Submitting job...

let i=1

while (( "$i" < "$NUM_FILES" )); do
    export FILE_START=$i
    echo Doing file $i plus 9 more if possible
    sbatch -o $STDOUT_DIR/run-bowtie2.out.$i $WORKER_DIR/make-bams.sh
    (( i += 10 ))
done
