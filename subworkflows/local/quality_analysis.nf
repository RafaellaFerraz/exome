

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { TRIMMOMATIC } from '../../modules/local/trimmomatic.nf'
include { FASTQC } from '../../modules/local/fastqc.nf'
include { MULTIQC } from '../../modules/local/multiqc.nf'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow QUALITY_ANALYSIS {
  take:
  reads
  adapters
  
  main:
  reads_ch = Channel.fromFilePairs(reads, checkIfExists: true)
  reads_trim_ch = TRIMMOMATIC(reads_ch, adapters)
  fastqc_ch = FASTQC(TRIMMOMATIC.out.reads_trim.map {id, path -> path})
  MULTIQC(FASTQC.out.html.mix(FASTQC.out.zip).collect())

  emit:
  
  reads_trimadas = TRIMMOMATIC.out.reads_trim
  fastqc_html = FASTQC.out.html
  fastqc_zip = FASTQC.out.zip
  multiqc_results = MULTIQC.out.multiqc_report

}
