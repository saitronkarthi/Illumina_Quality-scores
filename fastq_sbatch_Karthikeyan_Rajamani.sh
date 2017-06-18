#!/bin/bash

####set of directives interpreted by Slurm:
# Resource allocation
#SBATCH -J fastq         # job name
#SBATCH -o fastq.o%j     # output and error file name (%j expands to jobID)
#SBATCH -N 1                # number of nodes requested
#SBATCH -n 1                # total number of tasks requested
#SBATCH -p normal           # queue (partition) -- normal, development, etc.
#SBATCH -t 00:10:00         # run time (hh:mm:ss) - 1.5 hours
#SBATCH -A Course_Computational    # Project/allocation name(if more than one)

# Email notifications  
#SBATCH --mail-user=YourEmail  # provide your email 
#SBATCH --mail-type=begin      # email me when the job starts
#SBATCH --mail-type=end        # email me when the job finishes


#Your script
./HW7_fastqAnalysis_Karthikeyan_Rajamani.sh


#To submit from head node, use Slurm sbatch command: sbatch Test_sbatch.sh