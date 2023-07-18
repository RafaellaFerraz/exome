process GATK_VQRS_SNP {
    publishDir "${params.outdir}/gatk_results", mode:'copy'
    container 'pegi3s/gatk-4'

    label 'process_medium'

    input:
    tuple val(id), path(gvcf)
    path reference_genome
    path fai
    path dictionary
    path indels
    path dbsnp
    
    output:
    tuple val(id), path("*_VQSR1_INDEL.recal"), emit: recsnp_recal
    tuple val(id), path("*_VQSR1_INDEL.tranches"), emit: recsnp_tranches
    tuple val(id), path("*_VQSR1_INDEL.model"), emit: recsnp_model


    script:
    """
    gatk --java-options "-Xmx4G" ApplyVQSR \\
    -R $reference_genome \\
    -V ${gvcf} \\
    --truth-sensitivity-filter-level 95 -mode SNP \\
    -O MERGED_MERGED_GENOTYPED_SNP_recal.vcf \\
    --tranches-file MERGED_VQSR1_SNP.tranches \\
    --recal-file MERGED_VQSR1_SNP.recal
    """
}
