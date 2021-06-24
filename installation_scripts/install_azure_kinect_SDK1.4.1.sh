#######################################################################
##                  install azure kinect 1.4.1                       ##
#######################################################################

# Configuring the repositories
INSTALL_DIR=/azure_kinect_installation
mkdir ${INSTALL_DIR}
cd ${INSTALL_DIR}

echo "----------> Installing prerequisites --------"
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
apt-add-repository https://packages.microsoft.com/ubuntu/18.04/prod
apt-get update && apt-get install -y \
    ninja-build \
    doxygen \
    clang \
    gcc-multilib-arm-linux-gnueabihf \
    g++-multilib-arm-linux-gnueabihf && \
   rm -rf /var/lib/apt/lists/*

apt-get update && apt-get install -y \
    freeglut3-dev \
    libgl1-mesa-dev \
    mesa-common-dev \
    libsoundio-dev \
    libvulkan-dev \
    libxcursor-dev \
    libxinerama-dev \
    libxrandr-dev \
    uuid-dev \
    libsdl2-dev \
    usbutils \
    libusb-1.0-0-dev \
    openssl \
    libudev-dev\
    libssl-dev && \
    rm -rf /var/lib/apt/lists/*
echo "----------> Finish installing prerequisites --------"


# update cmake
echo "----------> Start building CMake 3.16.5 --------"
cd $INSTALL_DIR
wget https://cmake.org/files/v3.16/cmake-3.16.5.tar.gz  -O cmake-3.16.5.tar.gz
tar -zxvf cmake-3.16.5.tar.gz
cd $INSTALL_DIR/cmake-3.16.5
./bootstrap
make
make install
echo "----------> Finish building CMake 3.16.5 --------"



# install azure kinect sdk
echo "----------> Cloning azure-kinect-SDK--------"
cd $INSTALL_DIR
wget https://www.nuget.org/api/v2/package/Microsoft.Azure.Kinect.Sensor/1.4.1 -O microsoft.azure.kinect.sensor.1.4.1.nupkg
mv microsoft.azure.kinect.sensor.1.4.1.nupkg  microsoft.azure.kinect.sensor.1.4.1.zip
unzip -d microsoft.azure.kinect.sensor.1.4.1 microsoft.azure.kinect.sensor.1.4.1.zip

cd $INSTALL_DIR

git clone --recurse-submodules https://github.com/microsoft/Azure-Kinect-Sensor-SDK.git -b release/1.4.x
cd $INSTALL_DIR/Azure-Kinect-Sensor-SDK &&\
    git branch -a
mkdir -p ${INSTALL_DIR}/Azure-Kinect-Sensor-SDK/build/bin/
cp /microsoft.azure.kinect.sensor.1.4.1/linux/lib/native/x64/release/libdepthengine.so.2.0 ${INSTALL_DIR}/Azure-Kinect-Sensor-SDK/build/bin/libdepthengine.so.2.0
cp /microsoft.azure.kinect.sensor.1.4.1/linux/lib/native/x64/release/libdepthengine.so.2.0 /lib/x86_64-linux-gnu/
cp /microsoft.azure.kinect.sensor.1.4.1/linux/lib/native/x64/release/libdepthengine.so.2.0 /usr/lib/x86_64-linux-gnu/
chmod a+rwx /usr/lib/x86_64-linux-gnu
chmod a+rwx -R /lib/x86_64-linux-gnu/
chmod a+rwx -R ${INSTALL_DIR}/Azure-Kinect-Sensor-SDK/build/bin/

echo "----------> Start building azure-kinect-SDK--------"
cd ${INSTALL_DIR}/Azure-Kinect-Sensor-SDK/build && cmake .. -GNinja && ninja && ninja install

mkdir -p /etc/udev/rules.d/
cp ${INSTALL_DIR}/Azure-Kinect-Sensor-SDK/scripts/99-k4a.rules /etc/udev/rules.d/99-k4a.rules
chmod a+rwx /etc/udev/rules.d
echo "----------> Completed building azure-kinect-SDK--------"

# Remove the cloned data
rm -rf ${INSTALL_DIR}