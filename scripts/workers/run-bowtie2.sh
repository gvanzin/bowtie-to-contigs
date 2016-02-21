#!/bin/bash
#SBATCH -p normal           # Queue name
#SBATCH -J bowtie2
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                     # Total number of tasks
#SBATCH -t 24:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

set -u

module load perl
module load bowtie

echo "Started at $(date) on host $(hostname)"

CONFIG="$PRJ_DIR/scripts/config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo MIssing config \"$CONFIG\"
    exit 12385
fi

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

LEFT_TMP_FILES=$(mktemp)
RIGHT_TMP_FILES=$(mktemp)

get_lines $LEFT_FILES_LIST $LEFT_TMP_FILES $FILE_START $STEP_SIZE
get_lines $RIGHT_FILES_LIST $RIGHT_TMP_FILES $FILE_START $STEP_SIZE

NUM_FILES=$(lc $LEFT_TMP_FILES)

echo Found \"$NUM_FILES\" files to process
echo Processing $(cat $LEFT_TMP_FILES) and $(cat $RIGHT_TMP_FILES)

while read LEFT_FASTQ; do

    while read RIGHT_FASTQ; do

        test2=$(echo $RIGHT_FASTQ | sed s/R[1-2]//)
        test1=$(echo $LEFT_FASTQ | sed s/R[1-2]//)

        if [ "$test1" = "$test2" ]; then
            IN_LEFT=$FASTQ_DIR/$LEFT_FASTQ
            IN_RIGHT=$FASTQ_DIR/$RIGHT_FASTQ
           
            OUT_DIR=$BOWTIE2_OUT_DIR/$(dirname $LEFT_FASTQ)

            OUT=$OUT_DIR/$(basename $LEFT_FASTQ ".fa").sam

            if [[ ! -d "$OUT_DIR" ]]; then
                mkdir -p "$OUT_DIR"
            fi
            
            if [[ -e $OUT ]]; then
                echo "Sam file already exists, skipping..."
                continue
            else
                echo "Processing $LEFT_FASTQ"
            fi

            bowtie2 -p 16 \
                --very-sensitive-local \
                --no-unal \
                --no-sq \
                -k 1 \
                -x $BOWTIE2_DB \
                -1 $IN_LEFT \
                -2 $IN_RIGHT \
                -S $OUT
        else
            continue
        fi

        done < "$RIGHT_TMP_FILES"

done < "$LEFT_TMP_FILES"

echo "Done at $(date)"

