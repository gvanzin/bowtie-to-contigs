#!/bin/bash
#SBATCH -J bowtie2build           # Job name
#SBATCH -p serial           # Queue name
#SBATCH -N 1                     # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                     # Total number of tasks
#SBATCH -t 12:00:00              # Run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=scottdaniel@email.arizona.edu
#SBATCH --mail-type=all
#SBATCH -A iPlant-Collabs         # Specify allocation to charge against

set -u

module load perl
module load bowtie

echo "Started at $(date) on host $(hostname)"

echo "Bowtie2 indexing..."

bowtie2-build $CONTIGS $BOWTIE2_DB

echo "Done $(date)"
