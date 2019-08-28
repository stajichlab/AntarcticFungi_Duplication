#!/usr/bin/bash
#SBATCH -N 1 -n 4 -p short --out logs/fasta.%a.log -J fasta
module load fasta

CPUS=$SLURM_CPUS_ON_NODE
if [ -z $CPUS ]; then
	CPUS=1
fi
N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
    N=$1
    if [ -z $N ]; then
        echo "Need an array id or cmdline val for the job"
        exit
    fi
fi

INFILE=samples.tsv
PEPDIR=pep
PEPEXT=aa.fasta
CUTOFF=1e-15
OUT=results
mkdir -p $OUT
sed -n ${N}p $INFILE | while read NAME CLADE
do
	FILE=$PEPDIR/$NAME.$PEPEXT
	if [ ! -f $OUT/$NAME.FASTA.tab ]; then
		fasta36 -T $CPUS -E $CUTOFF -m 8c -d 0 $FILE $FILE > $OUT/$NAME.FASTA.tab
	fi
done
