#NOTE: This may look weird
#Because it was copied from another repo called taxoner-patric which was 
#copied from another repo called fizkin

export CWD=$PWD
export SCRIPT_DIR=$CWD

#your root working directory (not your $HOME but maybe it is)
export COMMON_DIR="/gsfs1/rsgrps/bhurwitz/scottdaniel"

#root project dir
export PRJ_DIR="$COMMON_DIR/bowtie-to-contigs"

#input contigs / also where bowtie2db will be
export CONTIG_DIR="$COMMON_DIR/spades_output"
export BOWTIE_DB=$CONTIG_DIR

#input fasta
#export FASTA_DIR="$PRJ_DIR/fasta"
export FASTA_DIR="/gsfs1/rsgrps/bhurwitz/kyclark/mouse/data/screened"

#place to store split-up fasta (step 00)
export ALT_DATA="/rsgrps/bhurwitz/scottdaniel/uproc_shortread_to_pfam/data"
export SPLIT_FA_DIR="$ALT_DATA/split-fasta"
#export SPLIT_FA_DIR="$PRJ_DIR/fasta-split"

#place that original fastq's are
export FASTQ_DIR="/gsfs1/rsgrps/bhurwitz/hurwitzlab/data/raw/Doetschman_20111007/all"

#place to store split up fastq's for searching later
export SPLIT_FQ_DIR="$PRJ_DIR/split-fastq"

#place to store bowtie2 results (step 01)
export BOWTIE2_OUT_DIR="$PRJ_DIR/bowtie2-out"

#where the worker scripts are (PBS batch scripts and their python/perl workdogs)
export WORKER_DIR="$PRJ_DIR/scripts/workers"

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
