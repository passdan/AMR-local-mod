Overview
--------
This repository is a modified version of the [AMR++ core repository](https://github.com/Microbial-Ecology-Group/AMRplusplus) with some notable modifications, changes, and parameterised for running on Cardiff University Biosciences compute cluster (Trinity). For usage and tutorials refer to the core AMR++ documentation.

Notable changes to original pipeline:
- Integrated fastp & bowtie2 as QC and alignment packages
  - Note: Default alignment for megares is kept as BWA consistent with original AMR++ and can be changed by parameter. Bowtie2 alignment against megaresDB has significant change on alignment rate.
- Based upon modified docker image (passdan/amrplusplus-update)
- Some code tweaks and fixes to work with singularity-slurm submission and repair nextflow channel bugs 
- Bespoke job submission and result caputre to fit our specific requirements
- Added Bracken processing with new results
  - Note: Two new workflow parameters: 'standard_AMR_wKraken_and_bracken' and 'kraken_and_braken' (for already filtered/host removed input)

Codebase is provided as-is and is hyper-locally modified for our infrastructure. If you are not concerned about bracken output or fastp & bowtie2 you probably want to work from the original AMR++ repository. 

---

# Preparing the install
1. Download the github repository with git clone and the url above

## Running with singularity
2. The pipeline is designed and configured to run with singularity & slurm. If you are using these then no further installation  preparation is required.
   You may choose to pre-build the singulariy images in advance if wanted. Note: config/singularity_slurm.conf is where singularity images can be defined.

## Download bowtie2 index files to remove contamination/host DNA
3. Either download directly, or build your indexes to be filtered against from user supplied fasta files.

[Recommended] download human genome indexes directly from: https://bowtie-bio.sourceforge.net/bowtie2/index.shtml

## Edit Slurm submission scripts
4. An example slurm script defines these parameters:
  1. workdir:     Location where processing will be performed (advice: use high speed location on your processing node i.e. /tmp)
  2. installdir:  Location of this github repo on your system
  3. resultsdir:  Where do you want the main outputs to be transfered to (not the full working folders & outputs)
  4. run:         Name of the run for annotation and folder where the fastq files are
                  Default input read location is: `$workdir/$run/fastq`
---

# Running the pipeline

Default pipeline is `standard_AMR_wKraken_and_bracken` which will run from raw fastqs to the endpoint. 

    Available pipelines:
        - demo: Run a demonstration of AMR++
        - standard_AMR: Run the standard AMR++ pipeline
        - fast_AMR: Run the fast AMR++ pipeline without host removal.
        - standard_AMR_wKraken: Run the standard AMR++ pipeline with Kraken
**NEW** - standard_AMR_wKraken_and_bracken: Run the standard AMR++ pipeline with Kraken AND Bracken

    Available subworkflows:
        - eval_qc: Run FastQC analysis
        - trim_qc: Run trimming and quality control
        - rm_host: Remove host reads
        - resistome: Perform resistome analysis
        - align: Perform alignment to MEGARes database
        - kraken: Perform Kraken analysis
**NEW** - kraken_and_bracken: Perform Kraken and Bracken analysis
        - qiime2: Perform QIIME 2 analysis
        - bam_resistome: Perform resistome analysis on BAM files


Alternatives are to use mid-process data, kraken only etc. by modifying the --pipeline parameter

Submit as a slurm & singularity job with:
```
sbatch AMRplusplus_full.sh
```
