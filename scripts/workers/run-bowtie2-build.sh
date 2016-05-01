#!/bin/bash
#SBATCH -J bowtie2build           # Job name
#SBATCH -p largemem           # Queue name
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 32                     # Total number of tasks
#SBATCH -t 24:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

#automagic offloading for the xeon phi co-processor
#in case anything uses Intel's Math Kernel Library
export MKL_MIC_ENABLE=1
export OMP_NUM_THREADS=32
export MIC_OMP_NUM_THREADS=480
export OFFLOAD_REPORT=2

set -u

module load perl
module load bowtie

echo "Started at $(date) on host $(hostname)"

echo "Bowtie2 indexing..."

bowtie2-build $CONTIGS $BOWTIE2_DB

echo "Done $(date)"
