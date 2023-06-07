process PICARD_DUP {
    publishDir "${params.outdir}/alinhamento_results", mode:'copy'
    container 'quay.io/biocontainers/picard:3.0.0--hdfd78af_0'

    label 'process_medium'

    input:
    tuple val(id), path(reorder_bam)

    output:
    tuple val(id), path("*_dup.bam"), emit: dup_bam
    path("*_reorder.bam.mtrcs"), emit: reorder_bam_mtrcs

    script:
    """
    picard MarkDuplicates \\
    -I ${reorder_bam} \\
    -O ${id}_dup.bam \\
    -METRICS_FILE ${id}_reorder.bam.mtrcs \\
    -REMOVE_DUPLICATES true \\
    -CREATE_INDEX true
    """
}