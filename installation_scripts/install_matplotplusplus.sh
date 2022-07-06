apt update -y
apt install -y gnuplot

apt-get install -y libglfw3-dev

cd /tmp
git clone https://github.com/alandefreitas/matplotplusplus.git
cd matplotplusplus
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O2" -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF 
cmake --build . --parallel 2 --config Release
cmake --install .
