
process FASTQC {
    publishDir "${params.outdir}/fastqc_results", mode:'copy'
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'
    label 'process_medium'

    input:
    path reads

    output:
    path("*.html"), emit: html
    path("*.zip") , emit: zip

    script:
    """
    fastqc ${reads} --threads $task.cpus
    """
}