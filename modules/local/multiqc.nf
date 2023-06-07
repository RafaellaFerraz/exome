
process MULTIQC {
    label 'process_low'
    container 'quay.io/biocontainers/multiqc:1.14--pyhdfd78af_0'
    publishDir params.outdir, mode:'copy'
    
    input:
    path '*'
    
    output:
    path 'multiqc_report.html', emit: multiqc_report

    script:
    """
    multiqc .
    """
}