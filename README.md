# EXOME_SEQ_PIPELINE
Python based command execution of exome sequencing analysis on the stanford genomics cluster
input example :
$python exome_file_command.py XXXXX_merged.bam (this pipeline accepts only BWA aligned bam file)

#######Dependancies required#######
picard-tools/2.14
gatk/3.7
hg19 and db138 resource bundle from GATK best practices pipeline
####### steps 1 to 7 ##############
each step after step1 holds untils the job is done

