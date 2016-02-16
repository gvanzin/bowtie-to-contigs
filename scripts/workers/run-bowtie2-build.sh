#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=6:mem=11gb
#PBS -l pvmem=22gb
#PBS -l place=pack:shared
#PBS -l walltime=48:00:00
#PBS -l cput=48:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $PBS_O_WORKDIR

set -u

module load bowtie2

echo "Started at $(date) on host $(hostname)"

source /usr/share/Modules/init/bash

echo "Bowtie2 indexing..."

bowtie2-build final_contigs.fasta final_contigs

echo "Done $(date)"
