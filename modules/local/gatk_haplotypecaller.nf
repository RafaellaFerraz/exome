process GATK_HAPLOTYPECALLER {
    publishDir "${params.outdir}/gatk_results", mode:'copy'
    container 'pegi3s/gatk-4'

    label 'process_medium'

    input:
    tuple val(id), path(bqsr_bam)
    path dbsnp
    path twist_exome
    path reference_genome
    path fai
    path dictionary

    output:
    tuple val(id), path("*_bqsr.vcf.gz"), emit: bqsr_haplotype

    script:
    """
    gatk --java-options "-Xmx4G" HaplotypeCaller \\
    -ERC GVCF \\
    --dbsnp $dbsnp \\
    --intervals $twist_exome \\
    --interval-padding 100 \\
    -R $reference_genome \\
    -O ${id}_bqsr.vcf.gz \\
    -G StandardAnnotation \\
    -G AS_StandardAnnotation \\
    -G StandardHCAnnotation \\
    -AX InbreedingCoeff \\
    --annotate-with-num-discovered-alleles \\
    -I ${bqsr_bam} \\
    -pairHMM LOGLESS_CACHING \\
    --native-pair-hmm-threads $task.cpus
    """
}
