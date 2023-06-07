

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { BWA } from '../../modules/local/bwa.nf'
include { PICARD_REPLACE } from '../../modules/local/picard_replace.nf'
include { PICARD_SORT } from '../../modules/local/picard_sort.nf'
include { PICARD_ORDER } from '../../modules/local/picard_order.nf'
include { PICARD_DUP } from '../../modules/local/picard_duplicated.nf'


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow ALIGMENT {
  take:
    reads_trimadas
    reference_genome
    dictionary
  
  main:
    bwa_ch = BWA(reads_trimadas, reference_genome)
    pireplace = PICARD_REPLACE(bwa_ch)
    pisort_ch = PICARD_SORT(pireplace)
    piord_ch = PICARD_ORDER(pisort_ch, reference_genome, dictionary)
    pidup_ch = PICARD_DUP(piord_ch)


  emit:
    bwa_saida = BWA.out.map_bam
    pireplace_saida = PICARD_REPLACE.out.replace_bam
    pisort_saida = PICARD_SORT.out.sorted_bam
    piorder_saida = PICARD_ORDER.out.reorder_bam
    pidup_saida = PICARD_DUP.out.dup_bam
    pidup_metric = PICARD_DUP.out.reorder_bam_mtrcs
  
}
