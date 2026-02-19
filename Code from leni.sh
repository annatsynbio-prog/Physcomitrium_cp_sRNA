#Bb_duk to trim adapters
/opt/bbmap/bbduk.sh in=SRNA4.fq.gz out=SRNA4.trimmed.fq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo

#Bbmap each merged fastq file - With filters
/opt/bbmap/bbmap.sh in=SRNA4.trimmed.fq.gz ref=/data/sRNA/02_assemblies/Arabidopsis/fasta/AP000423_1kb.fasta out=SRNA4.bam perfectmode=t

#Samtools sort
samtools sort -o SRNA4.sorted.bam SRNA4.bam

#Samtools index
samtools index SRNA4.sorted.bam
