#!/bin/bash
#$ -N Variant_Eval
#$ -l h_vmem=8G
#$ -l h_rt=24:00:00
#$ -pe shm 16
#$ -hold_jid VQSR_step4
module load java/8u66
module load R/3.4.1
gatk="GenomeAnalysisTK.jar"
java -jar $gatk \
-T VariantEval \
-R ucsc.hg19.fasta \
-eval recalibrated_variants.vcf \
-D dbsnp_138.hg19.vcf \
-noEV -EV CompOverlap -EV IndelSummary -EV TiTvVariantEvaluator -EV CountVariants -EV MultiallelicSummary \
-nt 16 \
-o recalibrated_Evaluation.eval.grp
