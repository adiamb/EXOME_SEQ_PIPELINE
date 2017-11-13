#!/bin/bash
#$ -N VQSR_step1
#$ -l h_vmem=64G
#$ -l h_rt=24:00:00
module load java/8u66
module load R/3.4.1
gatk="GenomeAnalysisTK.jar"
java -jar $gatk -T VariantRecalibrator -R ucsc.hg19.fasta -input combined_exome_interval_13_Nov.vcf -resource:hapmap,known=false,training=true,truth=true,prior=15.0 hapmap_3.3.hg19.sites.vcf -resource:omni,known=false,training=true,truth=true,prior=12.0 1000G_omni2.5.hg19.sites.vcf -resource:1000G,known=false,training=true,truth=false,prior=10.0 1000G_phase1.snps.high_confidence.hg19.sites.vcf -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 dbsnp_138.hg19.vcf -an QD -an FS -an SOR -an MQ -an MQRankSum -an ReadPosRankSum -an InbreedingCoeff -mode SNP -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 -recalFile recalibrate_SNP.recal -tranchesFile recalibrate_SNP.tranches -rscriptFile recalibrate_SNP_plots.R
