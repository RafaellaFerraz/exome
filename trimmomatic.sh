
trimmomatic PE \
	-threads 15 \
	./test_files/individuo1_1.fastq ./test_files/individuo1_2.fastq \
	./individuo1_1_trim.fastq.gz /dev/null \
	./individuo1_2_trim.fastq.gz /dev/null \
	ILLUMINACLIP:./reference_files/TruSeq3-PE.fa:2:30:10:2:True \
	LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:30

