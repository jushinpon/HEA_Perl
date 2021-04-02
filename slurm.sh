#!/bin/sh
#sed_anchor01
#SBATCH --output=Al17Mo17Nb17Ta17Ti17Zr17-swap.out
#SBATCH --job-name=Al17Mo17Nb17Ta17Ti17Zr17-swap
#SBATCH --nodes=1
##SBATCH --ntasks-per-node=12 
#SBATCH --partition=debug

export LD_LIBRARY_PATH=/opt/mpich-3.4.1/lib:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.1/bin:$PATH
#sed_anchor02
mpiexec /opt/lammps-mpich-3.4.1/lmp_20210329 -in /home/jsp/HEA_Perl/swap.in
