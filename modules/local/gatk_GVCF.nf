process GATK_GVCF {
    
    publishDir "${params.outdir}/gatk_results", mode:'copy'
    container 'pegi3s/gatk-4'

    label 'process_medium'

    input:
    tuple val(id), path(DBIMP)
    path reference_genome
    path fai
    path dictionary
    
    output:
    tuple val(id), path("merged_gvcf.vcf"), emit: gvcf
    
    script:
    """
    gatk --java-options "-Xmx4g" GenotypeGVCFs \\
    -R $reference_genome \\
    -V gendb://${DBIMP} \\
    -G StandardAnnotation \\
    --annotate-with-num-discovered-alleles \\
    -O merged_gvcf.vcf 
    """
}
