#!/bin/bash

workdir="/home/jupyter/workspace/rawdata/"
installdir="/home/jupyter/repos/AMR-local-mod"
resultsdir="AMRplusplus-selected-outputs"
run="S358_MiSeq_BHWNTNDRX5"


nextflow run ${installdir}/main_AMR++.nf \
	-w "${workdir}/${run}/work" \
	-c "${installdir}/config/singularity.config" \
	--reads "${workdir}/${run}/fastq/*{R1,R2}_001.fastq.gz" \
	--pipeline standard_AMR_wKraken_and_Bracken \
	--output "${workdir}/${run}/${run}-outputs" \
	--snp Y \
	-with-report "${workdir}/${run}/${run}.html" \
	-with-trace "${installdir}/logs/${SLURM_JOB_ID}.trace.txt" \
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
