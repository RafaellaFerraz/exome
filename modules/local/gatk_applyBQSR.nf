process GATK_APPLYBQSR {
    publishDir "${params.outdir}/gatk_results", mode:'copy'
    container 'pegi3s/gatk-4'

    label 'process_medium'

    input:
    tuple val(id), path(dup_bam)
    tuple val(id), path(rec_bam)
    path reference_genome
    path twist_exome
    path fai
    path dictionary

    output:
    tuple val(id), path("*_bqsr.bam"), emit: bqsr_bam

    script:
    """
    gatk --java-options "-Xmx4G" ApplyBQSR \\
    -R ${reference_genome} \\
    -L ${twist_exome} \\
    --interval-padding 100 \\
    -I ${dup_bam} \\
    -O ${id}_bqsr.bam \\
    --bqsr-recal-file ${rec_bam}
    """
}