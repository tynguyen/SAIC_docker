######################################
# INSTALL OPENCV ON UBUNTU OR DEBIAN
# Work with Cuda11.1
######################################

# -------------------------------------------------------------------- |
#                       SCRIPT OPTIONS                                 |
# ---------------------------------------------------------------------|
OPENCV_VERSION='4.7.0'       # Version to be installed
OPENCV_CONTRIB='YES'          # Install OpenCV's extra modules (YES/NO)
PYTHON_VERSION='python3.10'
# Get Python paths based on the Python version and where it is installed on the docker image
PYTHON_BIN=$(which $PYTHON_VERSION)
# echo "-----------------"
# echo "Get root dir to the python's bin path"
# iter=0
# for i in $(echo $PYTHON_BIN | tr "bin" " ")
# do
#   echo $i
#   if [ $iter -eq 0 ]
#   then
#     root_dir=$i
#     echo "iter = $iter, Set root_dir = $root_dir"
#   else
#     echo "iter = $iter, skip!"
#   fi
#   iter=$(($iter + 1))
# done
# echo "Root dir: ${root_dir}"

# # Other paths
# PYTHON_LIB=${root_dir}lib/python3.7
# PYTHON_INCLUDE=${root_dir}include/python3.7
# PYTHON_PKG_PATH=${root_dir}lib/python3.7/dist-packages
# PYTHON_NUMPY_INCLUDE=${root_dir}lib/python3.7/dist-packages/numpy/core/include

# Get Python paths based on the Python version and where it is installed on the docker image

# PYTHON_BIN=$($PYTHON_BIN -c "import sys; print(sys.executable)")
PYTHON_PKG_PATH=$($PYTHON_BIN -c 'import site; print(site.getsitepackages()[0])')
PYTHON_LIB=$($PYTHON_BIN -c "from sysconfig import get_paths as gp; print(gp()['stdlib'])")
PYTHON_INCLUDE=$($PYTHON_BIN -c "from sysconfig import get_paths as gp; print(gp()['include'])")
PYTHON_NUMPY_INCLUDE=$($PYTHON_BIN -c "import numpy; print(numpy.get_include())")

# echo $PYTHON_BIN
# echo $PYTHON_LIB
# echo $PYTHON_INCLUDE
# echo $PYTHON_PKG_PATH
# echo $PYTHON_NUMPY_INCLUDE

# Make sure python3.7 is default (instead of  python3.6)
#update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1
# -------------------------------------------------------------------- |

# |          THIS SCRIPT IS TESTED CORRECTLY ON          |
# |------------------------------------------------------|
# | OS               | OpenCV       | Test | Last test   |
# |------------------|--------------|------|-------------|
# | Ubuntu 20.04 LTS | OpenCV 4.2.0 | OK   | 25 Apr 2020 |
# |----------------------------------------------------- |
# | Debian 10.2      | OpenCV 4.2.0 | OK   | 26 Dec 2019 |
# |----------------------------------------------------- |
# | Debian 10.1      | OpenCV 4.1.1 | OK   | 28 Sep 2019 |
# |----------------------------------------------------- |
# | Ubuntu 18.04 LTS | OpenCV 4.1.0 | OK   | 22 Jun 2019 |
# | Debian 9.9       | OpenCV 4.1.0 | OK   | 22 Jun 2019 |
# |----------------------------------------------------- |
# | Ubuntu 18.04 LTS | OpenCV 3.4.2 | OK   | 18 Jul 2018 |
# | Debian 9.5       | OpenCV 3.4.2 | OK   | 18 Jul 2018 |



# 1. KEEP UBUNTU OR DEBIAN UP TO DATE

apt-get -y update
# apt-get -y upgrade       # Uncomment to install new versions of packages currently installed
# apt-get -y dist-upgrade  # Uncomment to handle changing dependencies with new vers. of pack.
# apt-get -y autoremove    # Uncomment to remove packages that are now no longer needed


# 2. INSTALL THE DEPENDENCIES

# Build tools:
apt-get install -y build-essential cmake

# GUI (if you want GTK, change 'qt5-default' to 'libgtkglext1-dev' and remove '-DWITH_QT=ON'):
apt-get install -y qt5-default libvtk6-dev

# Media I/O:
apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev \
                        libopenexr-dev libgdal-dev

# Video I/O:
apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev \
                        libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \
                        libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

# Parallelism and linear algebra libraries:
apt-get install -y libtbb-dev libeigen3-dev

# Python:
apt-get install -y python-dev  python-tk  pylint  python-numpy  \
                        python3-dev python3-tk pylint3 python3-numpy flake8

# Java:
apt-get install -y ant default-jdk

# Documentation and other:
apt-get install -y doxygen unzip wget


# 3. INSTALL THE LIBRARY

wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
mv opencv-${OPENCV_VERSION} OpenCV

if [ $OPENCV_CONTRIB = 'YES' ]; then
  wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip
  unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
  mv opencv_contrib-${OPENCV_VERSION} opencv_contrib
  mv opencv_contrib OpenCV
fi

cd OpenCV && mkdir build && cd build

if [ $OPENCV_CONTRIB = 'NO' ]; then
cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON
      -DPYTHON_DEFAULT_EXECUTABLE=$PYTHON_BIN \
      -DPYTHON_INCLUDE=$PYTHON_INCLUDE \
      -DPYTHON_LIBRARY=$PYTHON_LIB \
      -DPYTHON_PACKAGES_PATH=$PYTHON_PKG_PATH \
      -DPYTHON_NUMPY_INCLUDE_DIR=$PYTHON_NUMPY_INCLUDE \
      -DCMAKE_BUILD_TYPE=RELEASE \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF ..
fi

if [ $OPENCV_CONTRIB = 'YES' ]; then
cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON \
      -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF \
      -DWITH_CUDA=ON \
      -DPYTHON_DEFAULT_EXECUTABLE=$PYTHON_BIN \
      -DPYTHON_INCLUDE=$PYTHON_INCLUDE \
      -DPYTHON_LIBRARY=$PYTHON_LIB \
      -DPYTHON_PACKAGES_PATH=$PYTHON_PKG_PATH \
      -DPYTHON_NUMPY_INCLUDE_DIR=$PYTHON_NUMPY_INCLUDE \
      -DCMAKE_BUILD_TYPE=RELEASE \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules ..
fi

make -j8
make install
ldconfig


# For some unknown reasons, OpenCV has not worked with Python 3.7 yet.
# Use pip
if [ $OPENCV_CONTRIB = 'NO' ]; then
  $PYTHON_BIN -m pip install opencv-python==$OPENCV_VERSION
fi
if [ $OPENCV_CONTRIB = 'YES' ]; then
  $PYTHON_BIN -m pip install opencv-contrib-python==$OPENCV_VERSION
fi


# 4. EXECUTE SOME OPENCV EXAMPLES AND COMPILE A DEMONSTRATION

# To complete this step, please visit 'http://milq.github.io/install-opencv-ubuntu-debian'.
