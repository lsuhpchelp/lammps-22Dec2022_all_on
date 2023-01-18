#!/bin/bash
module purge
#module load /work/fchen14/lsuhpcspack/modules/linux-rhel7-cascadelake/gsl/2.5/gcc-9.3.0
#module load netcdf-c/4.7.3/intel-19.0.5-mvapich-2.3.3  netcdf-cxx/4.2/intel-19.0.5-mvapich-2.3.3  netcdf-fortran/4.5.2/intel-19.0.5-mvapich-2.3.3
module load gsl
module load git
module load python/3.7.6
#module load python/3.8.5-anaconda
module load gcc/9.3.0
#module load gcc/11.2.0
#module load cuda/10.2.89
#module load cuda/11.6.0
#module load cuda/11.2.2
module load cuda/11.3.1/intel-19.0.5
#module load cuda/11.0.2
#module load cuda/11.3.1/intel-19.0.5
#module load intel-mpi/2019.5.281
module load intel-mpi
module load cmake
export BLDDIR=bdsharedgcc
echo $CUDA_HOME
#exit
export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
export PROJECT_MPICC=$(which mpicxx)
mkdir -p $BLDDIR
rm -rf $BLDDIR/*
cd $BLDDIR
cmake \
-C ../cmake/presets/all_on.cmake \
-D CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME \
-D CMAKE_C_COMPILER=$(which mpicc) \
-D CMAKE_CXX_COMPILER=$(which mpicxx) \
-D CMAKE_Fortran_COMPILER=$(which mpif90) \
-D MPI_C_COMPILER=$(which mpicc) \
-D MPI_CXX_COMPILER=$(which mpicxx) \
-D PROJECT_MPICC=$(which mpicxx) \
-D MPIEXEC_EXECUTABLE=$(which mpirun) \
-D CMAKE_BUILD_TYPE=Release \
-D BUILD_MPI=ON \
-D BUILD_OMP=ON \
-D GPU_API=cuda \
-D GPU_ARCH=sm_75 \
-D BUILD_SHARED_LIBS=yes \
-D CMAKE_INSTALL_PREFIX=$PWD/../install \
../cmake
make -j48
make install
#cp $PWD/build-yaml-cpp/libyaml-cpp-pace.so* $PWD/../install/lib64
find . -name "*.so*" -exec cp "{}" $PWD/../install/lib64/ \;

