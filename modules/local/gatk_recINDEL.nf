process GATK_RECINDEL {
    publishDir "${params.outdir}/gatk_results", mode:'copy'
    container 'pegi3s/gatk-4'

    label 'process_medium'

    input:
    tuple val(id), path(gvcf)
    path reference_genome
    path fai
    path dictionary
    path hapmap
    path omni
    path phase
    path dbsnp
    
    output:
    tuple val(id), path("*_VQSR1_SNP.recal"), emit: recsnp_recal
    tuple val(id), path("*_VQSR1_SNP.tranches"), emit: recsnp_tranches
    tuple val(id), path("*_VQSR1_SNP.model"), emit: recsnp_model


    script:
    """
    gatk --java-options "-Xmx40g" VariantRecalibrator \\
    -R $reference_genome \\
    -V ${gvcf} \\
    --resource:hapmap,known=false,training=true,truth=true,prior=15.0 $hapmap \\
    --resource:omni,known=false,training=true,truth=true,prior=12.0 $omni \\
    --resource:1000G,known=false,training=true,truth=false,prior=10.0 $phase \\
    --resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $dbsnp \\
    -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR  \\
    --max-gaussians 4 -titv 3.2 --mode SNP \\
    -tranche 90.0 -tranche 95.0 -tranche 98.0 -tranche 99.0 -tranche 99.9 -tranche 100.0 \\
    -O ${id}_VQSR1_SNP.recal \\
    --tranches-file ${id}_VQSR1_SNP.tranches \\
    --output-model ${id}_VQSR1_SNP.model 

    gatk --java-options "-Xmx40g" VariantRecalibrator \\
    -R $reference_genome \\
    -V ${gvcf} \\--resource:mills,known=false,training=true,truth=true,prior=12.0 Mills_and_1000G_gold_standard.indels.hg38.vcf.gz --resource:dbsnp,known=true,training=false,truth=false,prior=2.0 dbSNP151.hg38.vcf.gz --max-gaussians 4 -an QD -an ReadPosRankSum -an FS -an SOR -an MQ -an MQRankSum -titv 3.2 -mode INDEL -tranche 90.0 -tranche 95.0 -tranche 98.0 -tranche 99.0 -tranche 99.9 -tranche 100.0 -O MERGED_VQSR1_INDEL.recal --tranches-file MERGED_VQSR1_INDEL.tranches --output-model MERGED_VQSR1_INDEL.model




    """
}
