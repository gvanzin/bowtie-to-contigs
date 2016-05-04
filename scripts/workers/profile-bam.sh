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

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

cd $FINAL_BAM_DIR

if [[ ! -e $SAMPLE.bam.bai ]]; then
    echo "Anvi-init-bam didnt work right"
else
    anvi-profile -i $SAMPLE.bam -M $MIN_CONTIG_SIZE -c $ANVI_CONTIG_DB
fi

echo Done at $(date)
