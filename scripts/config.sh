#NOTE: This may look weird
#Because it was copied from another repo called taxoner-patric which was 
#copied from another repo called fizkin

export CWD=$PWD
export SCRIPT_DIR=$CWD

#your root working directory (not your $HOME but maybe it is)
export COMMON_DIR="/work/03859/sdaniel"

#root project dir
export PRJ_DIR="$COMMON_DIR/bowtie-to-contigs"

#input contigs / also where bowtie2db will be
export CONTIG_DIR="$COMMON_DIR/megahit_output"
export CONTIGS="$CONTIG_DIR/final.contigs.fa"
export BOWTIE2_DB="$CONTIG_DIR/final.contigs"
export ANVI_CONTIG_DB="$CONTIG_DIR/anvi-contig.db"

#minimum contig size to get total contigs down to 20k
export MIN_CONTIG_SIZE="1696"

#input fasta
#export FASTA_DIR="$PRJ_DIR/fasta"
#export FASTA_DIR="/gsfs1/rsgrps/bhurwitz/kyclark/mouse/data/screened"

#place to store split-up fasta (step 00)
export SPLIT_FA_DIR="$COMMON_DIR/split_fasta"
#export SPLIT_FA_DIR="$PRJ_DIR/fasta-split"

#place that original fastq's are
export FASTQ_DIR="/work/03859/sdaniel/fastq-taxoner-patric/sort-and-merged"

#place to store split up fastq's for searching later
export SPLIT_FQ_DIR="$PRJ_DIR/split-fastq"

#place to store bowtie2 results (step 01)
#export BOWTIE2_OUT_DIR="$PRJ_DIR/bowtie2-out"
export BOWTIE2_OUT_DIR="$PRJ_DIR/bowtie2-out-for-anvi"

#place to store cat'd sam -> bams (step 02-03)
export BAM_OUT_DIR="$PRJ_DIR/bam-out"
export FINAL_BAM_DIR="$PRJ_DIR/bams-for-anvi"

#place to store bams (step 02-03)
export BAM_OUT_DIR="$PRJ_DIR/bam-out"
export FINAL_BAM_DIR="$PRJ_DIR/bams-for-anvi"

#where the worker scripts are (PBS batch scripts and their python/perl workdogs)
export WORKER_DIR="$PRJ_DIR/scripts/workers"

#sample names
export SAMPLE_NAMES="$PRJ_DIR/sample-names"

# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}
