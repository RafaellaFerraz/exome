process GATK_INDEX {
    publishDir "${params.outdir}/gatk_results", mode:'copy'
    container 'pegi3s/gatk-4'

    label 'process_medium'

    input:
    tuple val(id), path(vcf)

    output:
    tuple val(id), path("*vcf.gz.tbi"), emit: vcf_indexado
    
    script:
    """
    gatk IndexFeatureFile \\
         -I ${vcf}
         
    """
}
