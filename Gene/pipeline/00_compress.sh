#!/usr/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 4gb --out logs/compress.log
CPUS=$SLURM_CPUS_ON_NODE
if [ -z $CPUS ]; then
	CPUS=1
fi
INCDS=cds
INEXT=cds.fasta

parallel -j $CPUS pigz -k {} ::: $INCDS/*.$INEXT
