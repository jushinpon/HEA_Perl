#!/bin/sh
#sed_anchor01
#SBATCH --output=Al32Mo02Nb20Ta16Ti24Zr09.sout
#SBATCH --job-name=Al32Mo02Nb20Ta16Ti24Zr09
#SBATCH --nodes=1
#~ ##SBATCH --ntasks-per-node=12 
#SBATCH --partition=debug

export LD_LIBRARY_PATH=/opt/mpich-3.4.1/lib:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.4.1/bin:$PATH
#sed_anchor02
mpiexec /opt/lammps-mpich-3.4.1/lmp_20210329 -l none -in /home/jsp/HEA_Perl/initial-swap-optimize/Al32Mo02Nb20Ta16Ti24Zr09.in
