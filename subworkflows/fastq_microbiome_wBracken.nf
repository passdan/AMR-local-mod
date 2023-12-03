// Load modules
include { runkraken ; runbracken ; krakenresults ; brackenresults ; dlkraken} from '../modules/Microbiome/kraken_and_bracken.nf' 

workflow FASTQ_KRAKEN_AND_BRACKEN_WF {
    take: 
        read_pairs_ch
        krakendb
        taxlevel_ch
 
    main:
        if (params.kraken_db == null) {
            if (file("$baseDir/data/kraken_db/minikraken_8GB_20200312/").isDirectory()) {
                kraken_db_ch = Channel.fromPath("$baseDir/data/kraken_db/minikraken_8GB_20200312/")
            } else {
                dlkraken()
                kraken_db_ch = dlkraken.out
            }
        } else {
            kraken_db_ch = Channel.fromPath(params.kraken_db)
        }
	
	// Run Kraken
        runkraken(read_pairs_ch, krakendb)
        krakenresults(runkraken.out.kraken_report.collect())

        def combined_ch = runkraken.out.bracken_input.combine(taxlevel_ch).set { combined_input_ch }

        runbracken(combined_input_ch, krakendb)

	runbracken.out.bracken_by_level
        	.groupTuple()
	        .set { grouped_bracken_results }

        brackenresults(grouped_bracken_results)
        
}

