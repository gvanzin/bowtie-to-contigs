#!/usr/bin/env bash

#
# This script is intended to make bams from sams and then sort
#

unset module
set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=100 #adjust as needed

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

FILE_LIST="$PRJ_DIR/sam_files"

find $BOWTIE2_OUT_DIR -iname \*.sam > $FILE_LIST

export NUM_FILES=$(lc $FILE_LIST)

echo \"Found $NUM_FILES to make bams from\"

echo Making output dir...
if [ ! -d $BAM_OUT_DIR ]; then
    mkdir -p $BAM_OUT_DIR
fi

echo Submitting job...

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N makebam -j oe -o "$STDOUT_DIR" $WORKER_DIR/make-bams.pbs)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you. Weeeeee!
else
  echo -e "\nError submitting job\n$JOB\n"
fi
