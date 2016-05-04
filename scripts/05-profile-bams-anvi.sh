#!/usr/bin/env bash

#
# This script is intended to profile *.bams with anvio 
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

echo Checking that number of contigs is less than 20k

let m=$MIN_CONTIG_SIZE

echo "Minimum contig size is "$MIN_CONTIG_SIZE""

TOTAL_CONTIGS=$(sqlite3 $ANVI_CONTIG_DB "select count(*) from contigs_basic_info where length > "$MIN_CONTIG_SIZE";")

while [[ "$TOTAL_CONTIGS" -gt "20000" ]]; do
    
    echo Number of contigs "$TOTAL_CONTIGS" is too big, increasing MIN_CONTIG_SIZE
    (( m+=1 ))
    TOTAL_CONTIGS=$(sqlite3 $ANVI_CONTIG_DB "select count(*) from contigs_basic_info where length > "$MIN_CONTIG_SIZE";")
    export MIN_CONTIG_SIZE=$m

done

echo Minimum contig size is "$MIN_CONTIG_SIZE"
echo Number of contigs is "$TOTAL_CONTIGS" ... proceeding ...

while read SAMPLE; do

    #all this does is check for a profile.db it doesn't
    #check whether it was generated correctly
    TEST="$FINAL_BAM_DIR/$SAMPLE.bam-ANVIO_PROFILE/PROFILE.db"

    if [[ ! -s $TEST ]]; then
        echo $SAMPLE >> $SAMPLES_TO_PROCESS
    else
        continue
    fi

done < "$SAMPLE_NAMES"

export NUM_SAMPLES=$(lc $SAMPLES_TO_PROCESS)

echo \"Found $NUM_SAMPLES to profile with anvio\"
echo Submitting job...

let i=1
#use the following line after sbatch if you want it to happen after job_id
#--dependency=afterok:6619721 
while read SAMPLE; do
    export SAMPLE
    echo Doing sample $SAMPLE 
    qsub -V -j oe -o "$STDOUT_DIR" $WORKER_DIR/profile-bam.sh
    (( i += 1 ))
done < "$SAMPLES_TO_PROCESS"
