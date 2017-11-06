import sys
import subprocess
from subprocess import PIPE
file_in=sys.argv[1]

def qsub_o(str_o, java_func, command):
		f_o = open('ex'+str_o+'_'+str(java_func)+'.sh', 'w')
		if java_func == '1':
				f_o.write('#!/bin/bash'+'\n'
						+'#$ -N exo_'+str_o+'_'+str(java_func)+'\n'
						+'#$ -l h_vmem=16G'+'\n'
						+'#$ -l h_rt=6:00:00'+'\n'
						+'module load gatk/3.7'+'\n'
						+'module load picard-tools/2.8.0'+'\n'
						+'picard="picard.jar"'+'\n'
						+'gatk="/srv/gsfs0/software/gatk/gatk-3.7/GenomeAnalysisTK.jar"'+'\n' 
						+str(command)+'\n')
				f_o.close()
		else:
				f_o.write('#!/bin/bash'+'\n'
						+'#$ -N exo_'+str_o+'_'+str(java_func)+'\n'
						+'#$ -l h_vmem=16G'+'\n'
						+'#$ -l h_rt=6:00:00'+'\n'
						+'#$ -hold_jid exo_'+ str_o+'_'+str(int(java_func)-1)+'\n' ### job on hold until previous one is done
						+'module load gatk/3.7'+'\n'
						+'module load picard-tools/2.8.0'+'\n'
						+'picard="picard.jar"'+'\n'
						+'gatk="/srv/gsfs0/software/gatk/gatk-3.7/GenomeAnalysisTK.jar"'+'\n'
						+str(command)+'\n')
				f_o.close()
		subprocess.Popen('chmod 777 ex'+str_o+'_'+str(java_func)+'.sh', shell=True)
		subprocess.Popen('qsub -V -cwd ex'+str_o+'_'+str(java_func)+'.sh', shell=True)

def main(file_in):
	fileID=file_in.split('_')[0]
	sortsam='java -jar $picard SortSam I='+fileID+'_merged.bam O='+fileID+'_SORTED.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT'
	qsub_o(fileID, str(1), sortsam)
	reordersam='java -jar $picard ReorderSam I='+fileID+'_SORTED.bam '+'O='+fileID+'_SORTED_REORD.bam R=ucsc.hg19.fasta VALIDATION_STRINGENCY=LENIENT'
	qsub_o(fileID, str(2), reordersam)
	markdup='java -jar $picard MarkDuplicates I='+fileID+'_SORTED_REORD.bam O='+fileID+'_SORTED_REORD_DEDUP.bam M='+fileID+'_metrics.txt REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=LENIENT'
	qsub_o(fileID, str(3), markdup)
	bbindex='java -jar $picard BuildBamIndex I='+fileID+'_SORTED_REORD_DEDUP.bam VALIDATION_STRINGENCY=LENIENT'
	qsub_o(fileID, str(4), bbindex)
	basecal='java -jar $gatk -T BaseRecalibrator -R ucsc.hg19.fasta -I '+fileID+'_SORTED_REORD_DEDUP.bam -knownSites dbsnp_138.hg19.vcf -knownSites Mills_and_1000G_gold_standard.indels.hg19.sites.vcf -o '+fileID+'_RECAL.table'
	qsub_o(fileID, str(5), basecal)
	printreads='java -jar $gatk -T PrintReads -R ucsc.hg19.fasta -I '+fileID+'_SORTED_REORD_DEDUP.bam -BQSR '+fileID+'_RECAL.table -o '+fileID+'_RECAL_READS.bam'
	qsub_o(fileID, str(6), printreads)
	haplocall='java -jar $gatk -T HaplotypeCaller -R ucsc.hg19.fasta -I '+fileID+'_RECAL_READS.bam --dbsnp dbsnp_138.hg19.vcf --emitRefConfidence GVCF -o '+fileID+'.raw.snps.indels.g.vcf'
	qsub_o(fileID, str(7), haplocall)


if __name__ == '__main__':main(file_in)
						
