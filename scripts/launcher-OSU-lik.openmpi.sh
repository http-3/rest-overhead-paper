#!/bin/bash

#SBATCH -N 2
#SBATCH --ntasks-per-node=1
### -c, --cpus-per-task=<ncpus>
###     Request that ncpus be allocated per process
#SBATCH -c 1
#SBATCH --partition=compute
#SBATCH --time=00:55:00
#SBATCH --job-name=OSU99
#SBATCH --account=$USER

# limit stacksize ... adjust to your programs need
# and core file size
ulimit -s 102400
ulimit -c 0

# Environment settings to run a MPI parallel program
# compiled with OpenMPI and Mellanox HPC-X toolkit
# Load environment

# Settings for OpenMPI and MXM (MellanoX Messaging)
# library
# export OMPI_MCA_pml=cm
# export OMPI_MCA_mtl=mxm
# export OMPI_MCA_mtl_mxm_np=0
# export MXM_RDMA_PORTS=mlx5_0:1
 export MXM_LOG_LEVEL=ERROR
# Disable GHC algorithm for collective communication
export OMPI_MCA_coll=^ghc

##testing using different btl
##activate tcp
##export OMPI_MCA_btl=self,sm,tcp
##export OMPI_MCA_btl_tcp_if_exclude=eth0
##export OMPI_MCA_pml=ob1

#export OMPI_MCA_pmix_base_async_modex=0
##verbose logging 

#export OMPI_MCA_btl_base_verbose=100
### General SLURM Parameters
echo "SLURM_JOBID  = ${SLURM_JOBID}"
echo "SLURM_JOB_NODELIST = ${SLURM_JOB_NODELIST}"
echo "SLURM_NNODES = ${SLURM_NNODES}"
echo "SLURM_NTASKS = ${SLURM_NTASKS}"
echo "SLURMTMPDIR  = ${SLURMTMPDIR}"
echo "Submission directory = ${SLURM_SUBMIT_DIR}"
APPDIR="$HOME/ULHPC/tutorials/benchmarks/OSU_MicroBenchmarks/build.openmpi/libexec/osu-micro-benchmarks/mpi/one-sided"
TASK="${APPDIR}/$1"
RUNDIR=${SLURM_SUBMIT_DIR}

# Delay between each run
DELAY=1

likgroup=L2_LINES_IN_ALL:PMC0:KERNEL,L2_LINES_OUT_DEMAND_DIRTY:PMC1:KERNEL

#Modules to load
module purge
module load openmpi
module load likwid


[ -n "${SLURM_JOBID}" ] && JOBDIR="job-${SLURM_JOBID}" || JOBDIR="$(date +%Hh%Mm%S)"
DATADIR="${RUNDIR}/$(date +%Y-%m-%d)/${JOBDIR}"

if [ ! -d "${DATADIR}" ]; then
    echo "=> creating ${DATADIR}"
    mkdir -p ${DATADIR}
fi

  
for prog in osu_get_latency osu_get_bw; do
	     for (( i=0; i<=27;i++ ));do
				file=$((2**$i))	
    MPI_CMD="srun -l --propagate=STACK,CORE --cpu_bind=cores --distribution=block:cyclic likwid-perfctr --force -C 0 -g $likgroup -o liktest_${prog}_${file}_%h_%p_%r.txt"
    logfile="${DATADIR}/${prog}_${file}_$(date +%Hh%Mm%S).log"
    mpi_cmd="${MPI_CMD} ${APPDIR}/$prog -m $file:$file"
    echo "=> performing MPI OSU benchmark '${prog}' @ $(date) using:"
    echo "   ${mpi_cmd}"
        cat > ${logfile} <<EOF
# ${logfile}
# MPI Run '${prog}', Generated @ $(date) by:
#   $mpi_cmd
#
# SLURM_JOBID        $SLURM_JOBID
# SLURM_JOB_NODELIST $SLURM_JOB_NODELIST
# SLURM_NNODES       $SLURM_NNODES
# SLURM_NTASKS       $SLURM_NTASKS
# SLURM_SUBMIT_DIR   $SLURM_SUBMIT_DIR
### Starting timestamp: $(date +%s)
EOF
    cd ${DATADIR}
    echo "   command performed in $(pwd)"
    $mpi_cmd |& tee -a ${logfile}
    cd -
    cat >> ${logfile} <<EOF
### Ending timestamp:     $(date +%s)
EOF
    echo "=> now sleeping for ${DELAY}s"
    sleep $DELAY
done
done
echo "DONE"


