Overview
--------
This repository is a modified version of the [AMR++ core repository](https://github.com/Microbial-Ecology-Group/AMRplusplus) with some notable modifications, changes, and parameterised for running on Cardiff University Biosciences compute cluster (Trinity). For usage and tutorials refer to the core AMR++ documentation.

Notable changes to original pipeline:
- Integrated fastp & bowtie2 as QC and alignment packages
- Based upon modified docker image (passdan/amrplusplus-update)
- Some code tweaks and fixes to work with singularity-slurm submission and repair nextflow channel bugs 
- Bespoke job submission and result caputre to fit our specific requirements
- (Pending) Completed Bracken implementation

Codebase is provided as-is and is hyper-locally modified for our infrastructure. If you are not concerned about fastp & bowtie2 you probably want to work from the original AMR++ repository. 

# Running the pipeline

## Build singularity containers before running
Singularity containers can be pulled directly from dockerhub:
```
singularity build amrplusplus-update.sif docker://passdan/amrplusplus-update
singularity build bowtie_latest.sif docker://nanozoo/bowtie2:latest
```
Once completed, update the config file (```config/singularity_slurm.config```) with the locations on your system.

(Alternatively, docker/singularity images can be built using the container definitions in ```/envs/Containers/``` with:

```
sudo docker build . -t passdan/amrplusplus-update
```

## Download bowtie2 index files 
Either download directly,  or build your host indexes to be filtered against (here, removing all human genome matching short reads from the data)

Recommended, download directly from: https://bowtie-bio.sourceforge.net/bowtie2/index.shtml

## Edit Slurm submission scripts
There are example slurm scripts within the folder SUBMISSION_SCRIPTS. These aspects need editing:
1. workdir:     Location where processing will be performed (advice: use high speed location on your processing node i.e. /tmp)
2. installdir:  Location of this github repo on your system
3. resultsdir:  Where do you want the basic outputs to go (just the data matrices, not the large outputs)
4. run:         Name of the run for annotation and folder where the fastq files are

## Copy raw data to your working directory
Put the raw data somewhere on your system. The default slurm scripts are designed to look in:

```$workdir/$run/fastq```

## Run the process
Default pipeline is ```standard_AMR_wKraken``` which will run from raw fastqs to the endpoint. 

Alternatives are to use mid-process data, kraken only etc. by modifying the --pipeline parameter
```
sbatch SUBMISSION_SCRIPTS/AMRplusplus_full.sh
```
