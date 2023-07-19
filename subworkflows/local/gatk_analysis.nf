

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { GATK_BASE_RECALIBRATOR } from '../../modules/local/gatk_base_recalibrator.nf'
include { GATK_APPLYBQSR } from '../../modules/local/gatk_applyBQSR.nf'
include { GATK_HAPLOTYPECALLER } from '../../modules/local/gatk_haplotypecaller.nf'
include { GATK_INDEX } from '../../modules/local/gatk_index.nf'
include { GATK_DBI } from '../../modules/local/gatk_dbi.nf'
include { GATK_GVCF } from '../../modules/local/gatk_GVCF.nf'
include { GATK_RECSNP } from '../../modules/local/gatk_recSNP.nf'


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GATK_ANALYSIS {
  take:
    bam_aligment
    reference_genome
    twist_exome
    dbsnp
    thousand_genomes
    indels
    fai
    dictionary
    hapmap
    omni
    phase
  
  main:
    base_recalibrator_ch = GATK_BASE_RECALIBRATOR(bam_aligment, reference_genome, twist_exome, dbsnp, thousand_genomes, indels, fai, dictionary)
    applybqsr_ch = GATK_APPLYBQSR(bam_aligment, base_recalibrator_ch, reference_genome, twist_exome, fai, dictionary)
    haplotypecaller_ch = GATK_HAPLOTYPECALLER(applybqsr_ch, dbsnp, twist_exome, reference_genome, fai, dictionary)
    index_ch = GATK_INDEX(haplotypecaller_ch)
    haplotypecaller_ch.combine(index_ch, by: 0).set{combine_ch}
    dbi_ch = GATK_DBI(combine_ch)
    gvcf_ch = GATK_GVCF(dbi_ch, reference_genome, fai, dictionary)
 //   recsnp_ch = GATK_RECSNP(gvcf_ch, reference_genome, fai, dictionary, hapmap, omni, phase, dbsnp)      

  emit:
    base_recalibrator_saida = GATK_BASE_RECALIBRATOR.out.rec_bam
    applybqsr_saida = GATK_APPLYBQSR.out.bqsr_bam
    haplotypecaller_saida = GATK_HAPLOTYPECALLER.out.bqsr_haplotype
    index_saida = GATK_INDEX.out.vcf_indexado
    dbi_saida = GATK_DBI.out.dbimp
    gvcf_saida = GATK_GVCF.out.gvcf
//    recsnp_saida_recal = GATK_RECSNP.out.recsnp_recal
//    recsnp_saida_tranches = GATK_RECSNP.out.recsnp_tranches
//    recsnp_saida_model = GATK_RECSNP.out.recsnp_model

}
