
process TRIMMOMATIC {
	tag "Trimming ${id}"
	label 'process_medium'
	publishDir "${params.outdir}/reads_trimadas", mode:'copy'
	container 'quay.io/biocontainers/trimmomatic:0.39--hdfd78af_2'
	
	input:
	tuple val(id), path(reads)
	path adapters
	
	output:
	tuple val(id), path('*_{1,2}_trim.fastq.gz'), emit: reads_trim
	
	script:
	
	"""
	trimmomatic PE \\
		-threads $task.cpus \\
		${reads} \\
		${id}_1_trim.fastq.gz /dev/null \\
		${id}_2_trim.fastq.gz /dev/null \\
		ILLUMINACLIP:${adapters}:2:30:10:2:True \\
		LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:30
	"""
}
