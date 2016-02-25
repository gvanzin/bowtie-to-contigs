#!/usr/bin/env bash

#
# This script is intended to make bams from sams and then sort
#

unset module
set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=10

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

export FILE_LIST="$PRJ_DIR/sam_files"

find $BOWTIE2_OUT_DIR -iname \*.sam > $FILE_LIST

if [ ! -d $BAM_OUT_DIR ]; then
    mkdir -p $BAM_OUT_DIR
    echo "Making output dir..."
else
    echo "Continuing where you left off..."
fi

echo "Checking which ones are done already..."

if [ -e "$PRJ_DIR/files_to_process" ]; then
    rm $PRJ_DIR/files_to_process
fi

export FILES_TO_PROCESS="$PRJ_DIR/files_to_process"

while read FILE; do

    NEW_FILE=$(basename $FILE ".fastq.sam")
    
    if [[ ! -s $BAM_OUT_DIR/$NEW_FILE.bam  ]]; then
        echo $FILE >> $FILES_TO_PROCESS
    else
        continue
    fi

done < "$FILE_LIST"

export NUM_FILES=$(lc $FILES_TO_PROCESS)

echo \"Found $NUM_FILES to make bams from\"
echo \"Splitting them up in batches of "$STEP_SIZE"\"
echo Submitting job...

let i=1

while (( "$i" <= "$NUM_FILES" )); do
    export FILE_START=$i
    echo Doing file $i plus 9 more if possible
    sbatch --dependency=afterok:6613766 -o $STDOUT_DIR/make-bams-out.$i $WORKER_DIR/make-bams.sh
    (( i += $STEP_SIZE ))
done
