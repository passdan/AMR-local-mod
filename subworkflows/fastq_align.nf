// Load modules
//include { index ; bwa_align } from '../modules/Alignment/bwa'
include { bowtie2_index ; bowtie2_align } from '../modules/Alignment/bowtie2-for_AMRplusplus'

import java.nio.file.Paths

workflow FASTQ_ALIGN_WF {
    take: 
        read_pairs_ch
        amr

    main:
        // Define amr_index_files variable
        if (params.amr_index == null) {
            bowtie2_index(amr)
            amr_index_files = bowtie2_index.out
        } else {
            amr_index_files = Channel
               .fromPath(Paths.get(params.amr_index))
               .map { file(it.toString()) }
               .filter { file(it).exists() }
               .toList()
               .map { files ->
                   if (files.size() < 6) {
                       error "Expected 6 AMR index files, found ${files.size()}. Please provide all 6 files, including the AMR database fasta file. Remember to use * in your path."
                   } else {
                       files.sort()
                   }
               }
         }       
 
        // AMR alignment
        bowtie2_align(amr_index_files, read_pairs_ch )
}


