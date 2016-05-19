#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=serial
#PBS -l select=1:ncpus=1:mem=1gb:pcmem=2gb
#PBS -l place=pack:shared
#PBS -l walltime=5:00:00
#PBS -l cput=5:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

if [ -n "$PBS_O_WORKDIR" ]; then
    cd $PBS_O_WORKDIR
fi

set -u

while [ 1 ]; do
    sleep 5
    BLABLA=$(qstat -f 76.head1.cm.cluster | egrep 'job_state')
    if [[ "$BLABLA" =~ "Q" ]]; then
        echo "Job hasn't started yet"
        continue
    elif [[ "$BLABLA" =~ "R" ]]; then
        qstat -f 76.head1.cm.cluster | egrep 'resources_used.mem' >> mem_log_for_job_76.txt
        continue
    elif [[ "$BLABLA" =~ "E" ]]; then
        echo "Job is done" >> mem_log_for_job_76.txt
        exit 555
    fi
done
