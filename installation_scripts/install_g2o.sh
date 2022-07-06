apt-get update -y
apt-get install -y libsuitesparse-dev
apt-get install -y qtdeclarative5-dev
apt-get install -y qt5-qmake
apt-get install -y libqglviewer-dev-qt5
cd /tmp
git clone https://github.com/RainerKuemmerle/g2o.git
cd g2o
mkdir build && cd build
cmake ..
make -j 4
make install
