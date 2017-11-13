#!/bin/bash
#$ -N VQSR_step4
#$ -l h_vmem=64G
#$ -l h_rt=24:00:00
#$ -hold_jid VQSR_step3
module load java/8u66
module load R/3.4.1
gatk="GenomeAnalysisTK.jar"
java -jar $gatk -T ApplyRecalibration -R ucsc.hg19.fasta -input recalibrated_snps_raw_indels.vcf -mode INDEL --ts_filter_level 99.0 -recalFile recalibrate_INDEL.recal -tranchesFile recalibrate_INDEL.tranches -o recalibrated_variants.vcf
