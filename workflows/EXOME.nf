
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { QUALITY_ANALYSIS } from '../subworkflows/local/quality_analysis.nf'
include { ALIGMENT } from '../subworkflows/local/aligment.nf'
include { GATK_ANALYSIS } from '../subworkflows/local/gatk_analysis.nf'


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow EXOME {
   QUALITY_ANALYSIS(
    params.reads,
    params.adapters
   )
   ALIGMENT(
    QUALITY_ANALYSIS.out.reads_trimadas,
    params.reference_genome,
    params.dictionary
   )
   GATK_ANALYSIS(
    ALIGMENT.out.pidup_saida,
    params.reference_genome,
    params.twist_exome,
    params.dbsnp,
    params.thousand_genomes,
    params.indels,
    params.fai,
    params.dictionary,
    params.hapmap,
    params.omni,
    params.phase
   )
}
