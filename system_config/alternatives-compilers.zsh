#!/usr/bin/zsh

# Check for intel compiler
if [[ -z =icpc ]]; then
    icc=false;
else
    icc=true;
    icc_path=${$(which icc):h};
fi

# Check for Intel MPI
if [[ -z =mpicc ]]; then
    intel_mpi=false;
else
    intel_mpi=true;
    intel_mpi_path=${$(which mpiicpc):h};
fi

# Setup alternatives for g++ and gcc
sudo update-alternatives --install /usr/bin/g++ g++ =g++-6 10
sudo update-alternatives --install /usr/bin/g++ g++ =g++-4.9 1

sudo update-alternatives --install /usr/bin/gcc gcc =gcc-4.9 1
sudo update-alternatives --install /usr/bin/gcc gcc =gcc-6 10

# Setup alternatives for clang++ and clang
sudo update-alternatives --install /usr/bin/clang clang =clang-3.7 5
sudo update-alternatives --install /usr/bin/clang clang =clang-3.8 10
sudo update-alternatives --install /usr/bin/clang++ clang++ =clang++-3.8 10
sudo update-alternatives --install /usr/bin/clang++ clang++ =clang++-3.7 5

# Create generic compiler commands - cc and c++ 
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 80
sudo update-alternatives --install /usr/bin/cxx cxx /usr/bin/c++ 1000

sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 100
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 80

if ${icc}; then
    sudo update-alternatives --install /usr/bin/c++ c++ ${icc_path}/icpc 75
    sudo update-alternatives --install /usr/bin/cc cc ${icc_path}/icc 75
fi

# Set up alternatives for mpi if Intel MPI is installed on the system
# Create generic compiler commands for mpi wrapper
# This expects (relies) on the precedence of executables in  /usr/bin over other paths
if ${intel_mpi}; then
    sudo update-alternatives --install /usr/bin/mpicc mpicc ${intel_mpi_path}/mpiicc 75
    sudo update-alternatives --install /usr/bin/mpicc mpicc ${intel_mpi_path}/mpigcc 100
    sudo update-alternatives --install /usr/bin/mpicxx mpicxx ${intel_mpi_path}/mpiicpc 75
    sudo update-alternatives --install /usr/bin/mpicxx mpicxx ${intel_mpi_path}/mpigxx 100
    
fi
