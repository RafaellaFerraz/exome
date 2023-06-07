process PICARD_SORT {
    publishDir "${params.outdir}/alinhamento_results", mode:'copy'
    container 'quay.io/biocontainers/picard:3.0.0--hdfd78af_0'

    label 'process_medium'

    input:
    tuple val(id), path(replace_bam)

    output:
    tuple val(id), path("*sorted.bam"), emit: sorted_bam

    script:
    """
    picard SortSam INPUT=${replace_bam} \\
    OUTPUT=${id}_sorted.bam \\
    SORT_ORDER=coordinate \\
    VALIDATION_STRINGENCY=LENIENT
    """
}