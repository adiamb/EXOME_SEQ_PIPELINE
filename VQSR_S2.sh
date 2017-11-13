#!/bin/bash
#$ -N VQSR_step2
#$ -l h_vmem=64G
#$ -l h_rt=24:00:00
#$ -hold_jid VQSR_step1
module load java/8u66
module load R/3.4.1
gatk="GenomeAnalysisTK.jar"
java -jar $gatk -T ApplyRecalibration -R ucsc.hg19.fasta -input combined_exome_interval_13_Nov.vcf -mode SNP --ts_filter_level 99.0 -recalFile recalibrate_SNP.recal -tranchesFile recalibrate_SNP.tranches -o recalibrated_snps_raw_indels.vcf
