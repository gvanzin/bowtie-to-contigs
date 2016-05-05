#!/bin/bash

#SBATCH -J anvi-pop-genes           # Job name
#SBATCH -o ./out/anvi-pop-genes.%j.out    # Specify stdout output file (%j expands to jobId)
#SBATCH -p normal           # Queue name
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                     # Total number of tasks
#SBATCH -t 48:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

#automagic offloading for the xeon phi co-processor
#in case anything uses Intel's Math Kernel Library
export MKL_MIC_ENABLE=1
export OMP_NUM_THREADS=16
export MIC_OMP_NUM_THREADS=240
export OFFLOAD_REPORT=2

module load hdf5

CONFIG="./config.sh"

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

cd $CONTIG_DIR

echo "getting annotation from rast server, this is slowest step"
svr_assign_to_dna_using_figfams < $CONTIGS > svr_assign_to_dna_using_figfams.txt

echo "importing annotations into anvio contig database"
anvi-populate-genes-table -c $ANVI_CONTIG_DB -p myrast_cmdline_dont_use -i svr_assign_to_dna_using_figfams.txt

echo "saving annotation in more native format in case we need to re-import later"
anvi-export-genes-table -c $ANVI_CONTIG_DB -o rast_annotation.txt


