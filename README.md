Overview
--------
This repository is a modified version of the (AMR++ core repository)[https://github.com/Microbial-Ecology-Group/AMRplusplus] with some notable modifications, changes, and parameterised for running on Cardiff University Biosciences compute cluster (Trinity). For usage and tutorials refer to the core AMR++ documentation.

Notable changes to original pipeline:
- Integrated fastp & bowtie2 as QC and alignment packages
- Based upon modified docker image (passdan/amrplusplus-update)
- Some code tweaks and fixes to work with singularity-slurm submission and repair nextflow channel bugs 
- Bespoke job submission and result caputre to fit our specific requirements
- (Pending) Completed Bracken implementation

Codebase is provided as-is and is hyper-locally modified for our infrastructure. If you are not concerned about fastp & bowtie2 you probably want to work from the original AMR++ repository. 


