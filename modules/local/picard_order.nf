process PICARD_ORDER {
    publishDir "${params.outdir}/alinhamento_results", mode:'copy'
    container 'quay.io/biocontainers/picard:3.0.0--hdfd78af_0'

    label 'process_medium'

    input:
    tuple val(id), path(sorted_bam)
    path reference_genome
    path dictionary

    output:
    tuple val(id), path("*_reorder.bam"), emit: reorder_bam

    script:
    """
     picard ReorderSam -I ${sorted_bam} \\
     -O ${id}_reorder.bam \\
     -R $reference_genome \\
     -SEQUENCE_DICTIONARY $dictionary \\
     -ALLOW_CONTIG_LENGTH_DISCORDANCE true \\
     -VALIDATION_STRINGENCY LENIENT 
    """
}