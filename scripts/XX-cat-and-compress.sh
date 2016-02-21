#!/usr/bin/env bash

#
# This script is intended to concatenate sams into a single file per sample
# and then compress them into a single bam
#

unset module
set -u
source ./config.sh
export CWD="$PWD"
export STEP_SIZE=25 #adjust as needed

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

export DIR_LIST="$PRJ_DIR/dirs-to-cat"

find $BOWTIE2_OUT_DIR -maxdepth 1 -iname \*.fa > $DIR_LIST

export NUM_DIRS=$(lc $DIR_LIST)

echo \"Found $NUM_DIRS to make bams from\"

echo Making output dir...
if [ ! -d $CAT_OUT_DIR ]; then
    mkdir -p $CAT_OUT_DIR
fi

echo Submitting job...

JOB=$(qsub -J 1-$NUM_DIRS:$STEP_SIZE -V -N catsam -j oe -o "$STDOUT_DIR" $WORKER_DIR/cat-sams.pbs)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you. Weeeeee!
else
  echo -e "\nError submitting job\n$JOB\n"
fi
