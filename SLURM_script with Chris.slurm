#!/bin/bash --login
## These are the SLURM DIRECTIVES 
#SBATCH --job-name=Rscript_test
#SBATCH --partition=work
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --time=00:05:00
#SBATCH --output=Rscript_%A.out   
#SBATCH --export=NONE

# To load the application 
module load bbduk
module load bbmap
module load samtools

# leave in, it lists the environment loaded by the modules
module list

#  Note: SLURM_JOBID is a unique number for every job.
#  These are generic variables
EXECUTABLE=cl_arg.r
Data=/group/sms044/X201SC25118912-Z02-F001/01.RawData
# copy all file names over for local variables 
In_File1a=PpS1_FKDL250296486-1A_HGGT5DRX7_L1.fq.gz
Out_file=
In_File1b=
#need to create reference data directory for Physco
SCRATCH=$MYSCRATCH/run_Rscript/$SLURM_JOBID
RESULTS=$MYGROUP/Rscript_results/$SLURM_JOBID

###############################################
# Creates a unique directory in the SCRATCH directory for this job to run in.
if [ ! -d $SCRATCH ]; then 
    mkdir -p $SCRATCH 
fi 
echo SCRATCH is $SCRATCH

###############################################
# Creates a unique directory in your GROUP directory for the results of this job
if [ ! -d $RESULTS ]; then 
    mkdir -p $RESULTS 
fi
echo the results directory is $RESULTS

################################################
# declare the name of the output file or log file
OUTPUT=rscript.out

#############################################
#
#   cd to the directory where you type sbatch to submit job
#   Copy input files to $SCRATCH
#   then change directory to $SCRATCH

cd $SLURM_SUBMIT_DIR

# copy all the r/R files 
cp *.R $SCRATCH
# copy all .gz file in the raw data directory
# * for wildcard for all matching
cp $Data/PpS*/*.gz $SCRATCH

# cd to the SCRATCH directory where we have all raw files  
cd $SCRATCH

# show up in SLURM log for all things copied to SCRATCH
ls -al 
#############################################
#  execute the script 

# run the job
#Bb_duk to trim adapters
# echo to print out the command for troubleshooting 
# for checking all the variable names
bbduk in=$File1a out=SRNA4.trimmed.fq.gz
 ref=/opt/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo

#Bbmap each merged fastq file - With filters
bbmap in=SRNA4.trimmed.fq.gz ref=/data/sRNA/02_assemblies/Arabidopsis/fasta/AP000423_1kb.fasta /
out=SRNA4.bam perfectmode=t

#Samtools sort
# samtools sort -o output input 
samtools sort -o SRNA4.sorted.bam SRNA4.bam

#Samtools index
# samtools index sorted file 
samtools index SRNA4.sorted.bam

#############################################
#    $OUTPUT file to the unique results dir
# note this can be a copy or move  
mv  $OUTPUT ${RESULTS}

cd $HOME

###########################
# Clean up $SCRATCH 

rm -r $SCRATCH

echo Rscript single job finished at  `date`


