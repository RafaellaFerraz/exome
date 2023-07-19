process GATK_DBI {
    container 'quay.io/biocontainers/gatk4:4.4.0.0--py36hdfd78af_0'

    label 'process_medium'

    input:
    tuple val(id), path(bqsr_haplotype), path(vcf_indexado)
    
    output:
    tuple val(id), path("*_DBIMP"), emit: dbimp
    
    script:
    """
    gatk --java-options "-Xms4G -Xmx4G" GenomicsDBImport \\
    -V ${bqsr_haplotype} \\
    --reader-threads $task.cpus \\
    -L chr1 -L chr2 -L chr3 -L chr4 -L chr5 -L chr6 -L chr7 \\
    -L chr8 -L chr9 -L chr10 -L chr11 -L chr12 -L chr13 -L chr14 \\
    -L chr15 -L chr16 -L chr17 -L chr18 -L chr19 -L chr20 -L chr21 \\
    -L chr22 -L chrX -L chrY \\
    --genomicsdb-workspace-path ${id}_DBIMP \\
    --tmp-dir .
    """
}
