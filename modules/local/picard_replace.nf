process PICARD_REPLACE {
    publishDir "${params.outdir}/alinhamento_results", mode:'copy'
    container 'quay.io/biocontainers/picard:3.0.0--hdfd78af_0'

    label 'process_medium'

    input:
    tuple val(id), path(map_bam)

    output:
    tuple val(id), path("*_rep_map.bam"), emit: replace_bam

    script:
    """
       picard AddOrReplaceReadGroups \\
       I=${map_bam} \\
       O=${id}_rep_map.bam \\
       RGID=${id} \\
       RGLB=lib1 \\
       RGPL=ILLUMINA \\
       RGPU=unit1 \\
       RGSM=${id}
    """
}