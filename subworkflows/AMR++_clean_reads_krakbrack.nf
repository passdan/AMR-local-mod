include { FASTQ_RESISTOME_WF_BWA } from "$baseDir/subworkflows/fastq_resistome_bwa.nf"
include { FASTQ_KRAKEN_AND_BRACKEN_WF } from "$baseDir/subworkflows/fastq_microbiome_wBracken.nf"

workflow clean_reads_wKrak_and_Brack {
    take: 
        nonhost_reads
        amr
        annotation
        krakendb
	taxlevel_ch

    main:
        // AMR alignment
        FASTQ_RESISTOME_WF_BWA(nonhost_reads, amr, annotation)
        // Microbiome
        //FASTQ_KRAKEN_AND_BRACKEN_WF(nonhost_reads, params.kraken_db, taxlevel_ch)


}
