process GATK_BASE_RECALIBRATOR {
    publishDir "${params.outdir}/gatk_results", mode:'copy'
    container 'pegi3s/gatk-4'

    label 'process_medium'

    input:
    tuple val(id), path(dup_bam)
    path reference_genome
    path twist_exome
    path dbsnp
    path thousand_genomes
    path indels
    path fai
    path dictionary

    output:
    tuple val(id), path("*_rec.bam"), emit: rec_bam

    script:
    """
    gatk --java-options "-Xmx4G" BaseRecalibrator \\
    --intervals $twist_exome \\
    --interval-padding 100 \\
    -R $reference_genome \\
    -I ${dup_bam} \\
    -O ${id}_rec.bam \\
    --known-sites $dbsnp \\
    --known-sites $thousand_genomes \\
    --known-sites $indels
    """
}