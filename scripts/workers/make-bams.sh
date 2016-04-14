#!/bin/bash
#SBATCH -p normal           # Queue name
#SBATCH -J makebams
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                     # Total number of tasks
#SBATCH -t 24:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

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

get_lines $FILES_TO_PROCESS $TMP_FILES $FILE_START $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

echo Found \"$NUM_FILES\" files to process

while read FILE; do

    NEW_FILE=$(basename $FILE ".fastq.sam")

    if [[ ! -s $BAM_OUT_DIR/$NEW_FILE.bam ]]; then
        echo Converting $FILE using reference $CONTIGS
        samtools view -@ 16 -bT $CONTIGS $FILE > $FILE.temp
        echo Sorting $FILE
        samtools sort -@ 16 $FILE.temp > $BAM_OUT_DIR/$NEW_FILE.bam
        echo Removing $FILE.temp
        rm $FILE.temp
    else
        echo $FILE already done
    fi
done < "$TMP_FILES"

