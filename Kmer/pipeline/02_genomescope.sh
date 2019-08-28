#!/usr/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 100G -p short --out logs/genomescope.%a.log

module load jellyfish
GENOMESCOPE=../genomescope/genomescope.R
INFO=samples.csv
OUT=jf_counts
REPORT=genomescope
IN=fastq
KMER=21
READLEN=275
TEMP=/scratch
mkdir -p $OUT $REPORT

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

IFS=","
tail -n +2 $INFO | sed -n ${N}p | while read SAMPLE ORG RUN
do
    ORG=$(echo "$ORG" | perl -p -e 's/ /_/g')    
    IFS=';' read -r -a FILES <<< "$RUN"
    FILESUP=()
    for file in ${FILES[@]}
    do
	file="$IN/${file}_*.fastq.gz"
	FILESUP+=($file)
    done
    IFS=" " FILELIST="${FILESUP[*]}"
    echo "$FILELIST"
    if [ ! -f $OUT/$SAMPLE.jf ]; then
	pigz -dc $FILELIST > $TEMP/$SAMPLE.fastq
	jellyfish count -C -m $KMER -s 32000000000 -t $CPUS -o $OUT/$SAMPLE.jf $TEMP/$SAMPLE.fastq
	unlink $TEMP/$SAMPLE.fastq	
    fi
    if [[ -f $OUT/$SAMPLE.jf && ! -s $OUT/$SAMPLE.histo ]]; then
	jellyfish histo -t $CPUS $OUT/$SAMPLE.jf > $OUT/$SAMPLE.histo
    fi
    if [ -s $OUT/$SAMPLE.histo ]; then
	Rscript $GENOMESCOPE $OUT/$SAMPLE.histo $KMER $READLEN $REPORT/$ORG
    fi
done
# one more check to cleanup
if [ -f $TEMP/$SAMPLE.fastq ]; then
    unlink $TEMP/$SAMPLE.fastq
fi
