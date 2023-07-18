process BWA {
    publishDir "${params.outdir}/alinhamento_results", mode:'copy'
    container 'dukegcb/bwa-samtools'

    label 'process_medium'

    input:
    tuple val(id), path(reads)
    path reference_genome
    path fai
    path dictionary

    output:
    tuple val(id), path("*.map.bam") , emit: map_bam

    script:
    """
    bwa mem -t $task.cpus -M -R '@RG\\tID:${id}\\tSM:${id}\\tPL:ILLUMINA' $reference_genome \\
    $reads | samtools view -bS -h -F 4 - > ${id}.map.bam
    """
}