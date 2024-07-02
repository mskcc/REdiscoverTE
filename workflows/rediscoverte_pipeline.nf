/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { SALMON_INDEX } from '../modules/msk/salmon/index/main'
include { SALMON_QUANT } from '../modules/msk/salmon/quant/main'
include { REDISCOVERTE } from '../modules/msk/rediscoverte/main'
include { paramsSummaryMap       } from 'plugin/nf-validation'
include { paramsSummaryMultiqc   } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_rediscoverte_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow REDISCOVERTE_PIPELINE {

    take:
    ch_samplesheet // channel: samplesheet read in from --input

    main:

    ch_versions = Channel.empty()

    rollup_fasta = Channel.value(file(params.rollup_fasta))
    rmsk_annotation_RDS = Channel.value(file(params.rmsk_annotation_RDS))
    repName_repFamily_repClass_map_tsv = Channel.value(file(params.repName_repFamily_repClass_map_tsv))
    genecode_gene_annotation_RDS = Channel.value(file(params.genecode_gene_annotation_RDS))


    SALMON_INDEX( rollup_fasta )


    ch_versions = ch_versions.mix(SALMON_INDEX.out.versions)

    SALMON_QUANT( ch_samplesheet, SALMON_INDEX.out.index )

    ch_versions = ch_versions.mix(SALMON_QUANT.out.versions)

    quant_list = SALMON_QUANT.out.quant.map{ it[1]}.toList()

    REDISCOVERTE( quant_list, rmsk_annotation_RDS, repName_repFamily_repClass_map_tsv, genecode_gene_annotation_RDS)

    ch_versions = ch_versions.mix(REDISCOVERTE.out.versions)


    //
    // Collate and save software versions
    //
    softwareVersionsToYAML(ch_versions)
        .collectFile(
            storeDir: "${params.outdir}/pipeline_info",
            name: 'rediscoverte_pipeline_software_versions.yml',
            sort: true,
            newLine: true
        ).set { ch_collated_versions }


    emit:
    versions       = ch_versions                 // channel: [ path(versions.yml) ]
    rediscoverte   = REDISCOVERTE.out.rollup     // channel: [ path(rollup)]
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
