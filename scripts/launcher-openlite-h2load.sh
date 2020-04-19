#!/bin/bash
#SBATCH -N 2
#SBATCH --ntasks-per-node=1
### -c, --cpus-per-task=<ncpus>
###     Request that ncpus be allocated per process
#SBATCH -c 1
#SBATCH --partition=west
#SBATCH --time=00:10:00
#SBATCH --job-name=LIKBENCH99
#SBATCH --account=$USER


echo START

NODES=$(srun -w $SLURM_JOB_NODELIST hostname)
echo $NODES
set -- $NODES
SERVER=$1
CLIENT=$2
$PWD/openlite-h2load-bench.sh $CLIENT