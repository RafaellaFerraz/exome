process GATK_RECINDEL {
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
    gatk --java-options "-Xmx40g" VariantRecalibrator \\
    -R $reference_genome \\
    -V ${gvcf} \\
    --resource:mills,known=false,training=true,truth=true,prior=12.0 $indels \\
    --resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $dbsnp \\
    --max-gaussians 4 -an QD -an ReadPosRankSum -an FS -an SOR \\
    -an MQ -an MQRankSum -titv 3.2 -mode INDEL \\
    -tranche 90.0 -tranche 95.0 -tranche 98.0 -tranche 99.0 -tranche 99.9 -tranche 100.0 \\
    -O ${id}_VQSR1_INDEL.recal \\
    --tranches-file ${id}_VQSR1_INDEL.tranches \\
    --output-model ${id}_VQSR1_INDEL.model
    """
}
