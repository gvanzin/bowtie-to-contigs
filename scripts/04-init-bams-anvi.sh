#!/usr/bin/env bash

#
# This script is intended to initialize bams for use with anvi-profile 
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

export FILES_LIST="$PRJ_DIR/bam_files"

find $FINAL_BAM_DIR -iname \*raw.bam > $FILES_LIST

if [ ! -d $FINAL_BAM_DIR ]; then
    mkdir -p $FINAL_BAM_DIR
    echo "Making output dir..."
else
    echo "Continuing where you left off..."
fi

echo "Checking which ones are done already..."

if [ -e "$PRJ_DIR/samples_to_process" ]; then
    rm $PRJ_DIR/samples_to_process
fi

export SAMPLES_TO_PROCESS="$PRJ_DIR/samples_to_process"

echo Checking samples $(cat $SAMPLE_NAMES)

while read SAMPLE; do

    if [[ ! -s $FINAL_BAM_DIR/$SAMPLE.bam.bai ]]; then
        echo $SAMPLE >> $SAMPLES_TO_PROCESS
    else
        continue
    fi

done < "$SAMPLE_NAMES"

export NUM_SAMPLES=$(lc $SAMPLES_TO_PROCESS)

echo \"Found $NUM_SAMPLES to initialize for anvio\" 
echo Submitting job...

let i=1

while read SAMPLE; do
    export SAMPLE
    echo Doing sample $SAMPLE 
    sbatch -o $STDOUT_DIR/init-bam-anvi.out.$i $WORKER_DIR/init-bam-anvi.sh
    (( i += 1 ))
done < "$SAMPLES_TO_PROCESS"
