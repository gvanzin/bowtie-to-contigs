#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=12:mem=23gb:pcmem=2gb
#PBS -l pvmem=46gb
#PBS -l walltime=3:00:00
#PBS -l cput=3:00:00
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

cd $FINAL_BAM_DIR

if [[ ! -s $FINAL_BAM_DIR/$SAMPLE.bam.bai ]]; then
    echo Initializing "$SAMPLE".bam for anvio
    anvi-init-bam "$SAMPLE".raw.bam -O $SAMPLE
else
    echo $SAMPLE already done
fi

echo Done at $(date)
