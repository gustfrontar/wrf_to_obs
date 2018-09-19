#!/bin/sh
set -ex
PGM=obsope.exe
F90=mpif90
OMP=

F90OPT='-O3 -fconvert=big-endian' #-convert big_endian -O3 ' # -Hs' -Kfast,parallel

rm -f *.mod
rm -f *.o

cd ./src/main/

LIB_NETCDF="-L/usr/local/radx_libs/lib -lnetcdff"
INC_NETCDF="-I/usr/local/radx_libs/include/"


ln -fs ../common/SFMT.f90            ./
ln -fs ../common/common.f90          ./
ln -fs ../common/common_mpi.f90      ./
ln -fs ../common/common_smooth2d.f90 ./

ln -fs ../common_wrf/common_wrf.f90              ./
ln -fs ../common_wrf/common_mpi_wrf.f90          ./
ln -fs ../common_wrf/common_obs_wrf.f90          ./
ln -fs ../common_wrf/module_map_utils.f90        ./


$F90 $OMP $F90OPT -c SFMT.f90
$F90 $OMP $F90OPT -c common.f90
$F90 $OMP $F90OPT -c common_mpi.f90
$F90 $OMP $F90OPT -c module_map_utils.f90
$F90 $OMP $F90OPT $INC_NETCDF -c common_wrf.f90
$F90 $OMP $F90OPT -c common_namelist.f90
$F90 $OMP $F90OPT -c common_smooth2d.f90
$F90 $OMP $F90OPT -c common_obs_wrf.f90
$F90 $OMP $F90OPT -c common_mpi_wrf.f90
$F90 $OMP $F90OPT -c obsope_tools.f90
$F90 $OMP $F90OPT -c obsope.f90
$F90 $OMP $F90OPT -o ${PGM} *.o  $LIB_NETCDF 

mv *.exe ../

rm -f *.mod
rm -f *.o
rm -f netlib2.f

rm SFMT.f90 
rm common.f90 
rm common_mpi.f90 
rm common_wrf.f90 
rm common_mpi_wrf.f90 
rm common_obs_wrf.f90
rm module_map_utils.f90 
rm common_smooth2d.f90

echo "NORMAL END"
