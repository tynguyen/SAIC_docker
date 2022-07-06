cd /tmp
git clone --recurse-submodules https://github.com/strasdat/Sophus.git
cd Sophus
mkdir build && cd build
cmake ..
make -j4
