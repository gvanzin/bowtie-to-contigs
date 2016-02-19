
set -u

module load bowtie2

echo "Started at $(date) on host $(hostname)"

echo "Bowtie2 indexing..."

bowtie2-build $CONTIGS $BOWTIE2_DB

echo "Done $(date)"
