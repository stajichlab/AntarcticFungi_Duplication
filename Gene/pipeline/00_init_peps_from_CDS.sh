#!/usr/bin/bash
#SBATCH -p short -N 1 -n 24 --mem 2gb --out logs/init_peps.log
module unload perl
module unload miniconda2
module load miniconda3
CPUS=$SLURM_CPUS_ON_NODE
if [ -z $CPUS ]; then
	CPUS=1
fi
INCDS=cds
OUTPEP=pep
INEXT=cds.fasta.gz
OUTEXT=aa.fasta
mkdir -p $OUTPEP

parallel --rpl "{base} \$Global::use{\"File::Basename\"} ||= eval 'use File::Basename; 1;'; \$_ = basename(\$_); s/\Q.$INEXT\E$//;" \
        -j $CPUS "pigz -dc {} | ./scripts/bp_translate_seq.pl > $OUTPEP/{base}.$OUTEXT" ::: $INCDS/*.$INEXT

