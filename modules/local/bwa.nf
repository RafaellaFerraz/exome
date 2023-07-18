process BWA {
    publishDir "${params.outdir}/alinhamento_results", mode:'copy'
 //   container 'biocontainers/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:219b6c272b25e7e642ae3ff0bf0c5c81a5135ab4-0'
    container 'dukegcb/bwa-samtools'

    label 'process_medium'

    input:
    tuple val(id), path(reads)
    path reference_genome
    path amb
    path ann
    path bwt
    path pac
    path sa

    output:
    tuple val(id), path("*.map.bam") , emit: map_bam

    script:
    """
    bwa mem -t $task.cpus -M -R '@RG\\tID:${id}\\tSM:${id}\\tPL:ILLUMINA' $reference_genome \\
    Homo_sapiens_assembly38 $reads | samtools view -bS -h -F 4 - > ${id}.map.bam
    """
}