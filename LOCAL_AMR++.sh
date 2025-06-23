#!/bin/bash

run="S358_MiSeq_BHWNTNDRX5"

export NXF_SINGULARITY_CACHEDIR="gs://rawdata-wb-farms/singularities"


wb nextflow run main_AMR++.nf \
	-profile gls \
	--reads "gs://rawdata-wb-farms/${run}/fastq/C*{R1,R2}.fastq.gz" \
	--pipeline preprocess \
	--output "gs://rawdata-wb-farms/${run}-outputs" \
	--snp Y \
	-with-report "${run}.html" \
	-with-trace "${run}.trace.txt" 

#singularity exec docker://multiqc/multiqc:latest multiqc -o ${workdir}/${run}/${run}-outputs/Results/ ${workdir}/${run}/${run}-outputs

####
# Results copyout
####
#mkdir ${resultsdir}/${run}
#rsync -r ${workdir}/${run}/${run}-outputs/HostRemoval/NonHostFastq ${resultsdir}/$run/
#rsync -r ${workdir}/${run}/${run}-outputs/Results ${resultsdir}/$run/
#rsync ${workdir}/${run}/${run}.html ${resultsdir}/$run/

## Delete all
#rm -rf ${workdir}/${run}
