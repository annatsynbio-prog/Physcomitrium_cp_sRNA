# Resource definitions 
# SLURM setup
SBATCH
#!/bin/bash --login

#SBATCH --job-name=<map_da_reads>
#SBATCH --partition=peb
#SBATCH --mem-per-cpu=10G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=4:00:00   
#SBATCH --export=NONE
#SBATCH --mail-user=<uwa_email_address>@uwa.edu.au
#SBATCH --mail-type=BEGIN,END

# environment setup 
# load all necessary modules 
module load Bb_duk
module load Bb_map
module load samtools

# show what modules are loaded in the environment 
module list 

# define variables required for the script 

# data setup 

# run the job
#Bb_duk to trim adapters
/opt/bbmap/bbduk.sh in=SRNA4.fq.gz out=SRNA4.trimmed.fq.gz ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo

#Bbmap each merged fastq file - With filters
/opt/bbmap/bbmap.sh in=SRNA4.trimmed.fq.gz ref=/data/sRNA/02_assemblies/Arabidopsis/fasta/AP000423_1kb.fasta out=SRNA4.bam perfectmode=t

#Samtools sort
samtools sort -o SRNA4.sorted.bam SRNA4.bam

#Samtools index
samtools index SRNA4.sorted.bam

# cleanup 
