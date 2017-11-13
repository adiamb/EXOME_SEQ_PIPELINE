#!/bin/bash
#$ -N VQSR_step3
#$ -l h_vmem=64G
#$ -l h_rt=24:00:00
#$ -hold_jid VQSR_step2
module load java/8u66
module load R/3.4.1
gatk="GenomeAnalysisTK.jar"
java -jar $gatk -T VariantRecalibrator -R ucsc.hg19.fasta -input recalibrated_snps_raw_indels.vcf -resource:mills,known=false,training=true,truth=true,prior=12.0 Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 dbsnp_138.hg19.vcf -an QD -an FS -an SOR -an MQRankSum -an ReadPosRankSum -an InbreedingCoeff -mode INDEL -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 --maxGaussians 4 -recalFile recalibrate_INDEL.recal -tranchesFile recalibrate_INDEL.tranches -rscriptFile recalibrate_INDEL_plots.R
