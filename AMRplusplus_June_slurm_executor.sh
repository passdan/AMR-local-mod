#!/bin/bash
#SBATCH --partition=epyc_ssd       # the requested queue
#SBATCH --nodes=1              # number of nodes to use
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=2      #
#SBATCH --mem=4000	     # in megabytes, unless unit explicitly stated
#SBATCH --error=logs/%J.err         # redirect stderr to this file
#SBATCH --output=logs/%J.out        # redirect stdout to this file
##SBATCH --mail-user=passD1@Cardiff.ac.uk  # email address used for event notification
##SBATCH --mail-type=end                                   # email on job end
##SBATCH --mail-type=fail                                  # email on job failure
 
 
echo "Some Usable Environment Variables:"
echo "================================="
echo "hostname=$(hostname)"
echo \$SLURM_JOB_ID=${SLURM_JOB_ID}
echo \$SLURM_NTASKS=${SLURM_NTASKS}
echo \$SLURM_NTASKS_PER_NODE=${SLURM_NTASKS_PER_NODE}
echo \$SLURM_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK}
echo \$SLURM_JOB_CPUS_PER_NODE=${SLURM_JOB_CPUS_PER_NODE}
echo \$SLURM_MEM_PER_NODE=${SLURM_MEM_PER_NODE}

module purge
module load nextflow/21.10
module load singularity/3.8.7

export NXF_OPTS="-Xms500M -Xmx2G"

workdir="/tmp"
datadir="/mnt/scratch2/GROUP-smbpk"
installdir="/trinity/home/sbidp3/data/AMRplusplus/"
run="AMR_June2023"

nextflow run main_AMR++.nf \
	-w "${workdir}/${run}/work" \
	-c "${installdir}/config/singularity_slurm.config" \
	--reads "${datadir}/${run}/fastq/*{1,2}.fastq.gz" \
	--bam_files "${datadir}/${run}/AMRplusplus-out-${run}-repeat/Alignment/BAM_files/Standard/*bam" \
	--pipeline bam_resistome \
	--output "${workdir}/${run}/AMRplusplus-kraken-${run}" \
	-with-report "${datadir}/${run}/${run}.html" \
	-with-trace "${installdir}/logs/${SLURM_JOB_ID}.trace.txt" \
	--snp Y \
	-resume 
