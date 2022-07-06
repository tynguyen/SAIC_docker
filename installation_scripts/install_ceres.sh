# CMake
apt-get install -y cmake
# google-glog + gflags
apt-get install -y libgoogle-glog-dev libgflags-dev
# BLAS & LAPACK
apt-get install -y libatlas-base-dev
# Eigen3
apt-get install -y libeigen3-dev
# SuiteSparse and CXSparse (optional)
apt-get install -y libsuitesparse-dev

cd /tmp
git clone https://ceres-solver.googlesource.com/ceres-solver
cd ceres-solver
mkdir ceres-bin
cd ceres-bin
cmake ..
make -j3
make test
# Optionally install Ceres, it can also be exported using CMake which
# allows Ceres to be used without requiring installation, see the documentation
# for the EXPORT_BUILD_DIR option for more information.
make install

