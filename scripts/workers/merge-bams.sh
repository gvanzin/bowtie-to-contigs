#!/bin/bash
#SBATCH -p normal           # Queue name
#SBATCH -J merge-bams
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                     # Total number of tasks
#SBATCH -t 24:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

echo Started at $(date)

#automagic offloading for the xeon phi co-processor
#in case anything uses Intel's Math Kernel Library
export MKL_MIC_ENABLE=1
export OMP_NUM_THREADS=16
export MIC_OMP_NUM_THREADS=240
export OFFLOAD_REPORT=2

set -u

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
    echo Merging multiple bams into "$SAMPLE".bam
    rm $FINAL_BAM_DIR/$SAMPLE.bam
    samtools merge -@ 16 -b $TMP_FILES $FINAL_BAM_DIR/$SAMPLE.bam
else
    echo $SAMPLE already done
fi

echo Done at $(date)
