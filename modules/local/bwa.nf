process BWA {
    publishDir "${params.outdir}/alinhamento_results", mode:'copy'
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
    INDEX=`find -L ./ -name "*.amb" | sed 's/\\.amb\$//'`
    bwa mem -t $task.cpus -M -R '@RG\\tID:${id}\\tSM:${id}\\tPL:ILLUMINA' $reference_genome \\
    \$INDEX $reads | samtools view -bS -h -F 4 - > ${id}.map.bam
    """
}