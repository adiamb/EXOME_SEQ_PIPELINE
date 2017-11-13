# EXOME_SEQ_PIPELINE
Python based command execution of exome sequencing analysis on the stanford genomics cluster
input example :
$python exome_file_command.py XXXXX_merged.bam (this pipeline accepts only BWA aligned bam file)

# STEPS - follows the GATK best practices
1. SORT the bwa aligned file - tool used is picard - function is SortSam
2. Reorder the SORTED bam file using hg19 coordinates - picard function is ReorderSam
3. Mark duplicates in the Reordered bam - picard function is MarkDuplicates
4. Build the bam index of dedup bam - picard function is BuildBamIndex
5. Base Recalibration of the dedup bam file - GATK function is BaseRecalibrator
6. Output the calibrated reads - GATK function is PrintReads
7. call the genotypes directly or to g.vcf file if many >30 samples - GATK function is HaplotypeCaller
8. use scripts VQSR_S1 to VQSR_S4 for variant filtration using GATK bext practices
9. Perform Variant evaluation - expected Ti/Tv ratio for whole exome - 3 to 3.3

Dependancies required
picard-tools/2.14
gatk/3.7
hg19.fasta, Mills_and_1000G_gold_standard.indels.hg19.sites.vcf, db138 resource bundle from GATK best practices pipeline

# ONLY TO BE USED ON A SUN GRID ENGINE JOB SUBMISSION CLUSTER with QSUB


