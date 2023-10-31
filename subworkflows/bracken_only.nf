// Load modules
include { runbracken ; brackenresults ; dlkraken} from '../modules/Microbiome/test_kraken2.nf' 

workflow BRACKEN_ONLY {
    take: 
        kraken_reports_ch
        kraken_filtered_reports_ch
        krakendb

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
	

	//run bracken
	taxlevel_list = params.taxlevel.tokenize(',')

        taxlevel_list.each { level ->
            runbracken(kraken_reports_ch, krakendb, level)
            brackenresults(runbracken.out.bracken_out.collect(), level)
	}


	//runbracken(kraken_reports_ch, krakendb)
	//brackenresults(runbracken.out.bracken_out.collect())
}

