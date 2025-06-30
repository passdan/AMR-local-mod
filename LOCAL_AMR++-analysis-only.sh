#!/bin/bash

run="S358_MiSeq_BHWNTNDRX5"

export NXF_SINGULARITY_CACHEDIR="singularities"


nextflow run main_AMR++.nf \
	-profile singularity \
	-work-dir "/mnt/data/work" \
	--clean_reads "/mnt/data/NonHost/*{R1,R2}.fastq.gz" \
	--pipeline "clean_reads_wKrak_and_Brack" \
	--output "/mnt/data/analysis-outputs" \
	--snp N \
	-with-report "${run}-analysis.html" \
	-with-trace "${run}-analysis.trace.txt" \
        -resume	


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
