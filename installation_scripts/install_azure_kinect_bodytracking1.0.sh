echo "----------> Start building azure-kinect-body tracking--------"
wget https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4abt1.0-dev/libk4abt1.0-dev_1.0.0_amd64.deb
wget https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4abt1.0/libk4abt1.0_1.0.0_amd64.deb
mkdir -p /install
dpkg -x ./libk4abt1.0-dev_1.0.0_amd64.deb /install/libk4abt1.0
dpkg -x ./libk4abt1.0_1.0.0_amd64.deb /install/libk4abt1.0
apt-get update && apt-get install -y \
    libxi-dev && \
    rm -rf /var/lib/apt/lists/*
    
cp $PKG_LIST_DIR/kinect_include/k4abtConfig.cmake /install/libk4abt1.0/usr/lib/cmake/k4abt/k4abtConfig.cmake 

cd /
git clone --recurse-submodules https://github.com/microsoft/Azure-Kinect-Samples.git /home/Azure-Kinect-Samples

cp /install/libk4abt1.0/usr/lib/libk4abt.so /lib/x86_64-linux-gnu/
cp /install/libk4abt1.0/usr/lib/libk4abt.so /usr/lib/x86_64-linux-gnu/
cp /install/libk4abt1.0/usr/lib/libk4abt.so.1.0.0 /lib/x86_64-linux-gnu/
cp /install/libk4abt1.0/usr/lib/libk4abt.so.1.0.0 /usr/lib/x86_64-linux-gnu/
#
# cp /home/Azure-Kinect-Sensor-SDK/build/bin/libk4a.so /lib/x86_64-linux-gnu/
# cp /home/Azure-Kinect-Sensor-SDK/build/bin/libk4a.so /usr/lib/x86_64-linux-gnu/
# cp /home/Azure-Kinect-Sensor-SDK/build/bin/libk4a.so.1.3 /lib/x86_64-linux-gnu/
# cp /home/Azure-Kinect-Sensor-SDK/build/bin/libk4a.so.1.3 /usr/lib/x86_64-linux-gnu/
cp /home/Azure-Kinect-Sensor-SDK/build/bin/libk4a.so.1.3.0 /lib/x86_64-linux-gnu/
cp /home/Azure-Kinect-Sensor-SDK/build/bin/libk4a.so.1.3.0 /usr/lib/x86_64-linux-gnu/
#
# cp /home/Azure-Kinect-Sensor-SDK/build/bin/libk4arecord.so /lib/x86_64-linux-gnu/
# cp /home/Azure-Kinect-Sensor-SDK/build/bin/libk4arecord.so /usr/lib/x86_64-linux-gnu/

cp /install/libk4abt1.0/usr/include/k4abt.h /usr/include/ 
cp /install/libk4abt1.0/usr/include/k4abt.hpp /usr/include/
cp /install/libk4abt1.0/usr/include/k4abttypes.h /usr/include/
cp /install/libk4abt1.0/usr/include/k4abtversion.h /usr/include/

cp -r  /home/Azure-Kinect-Sensor-SDK/include/k4a/ /usr/include/
cp -r /home/Azure-Kinect-Sensor-SDK/include/k4ainternal/ /usr/include/
cp -r /home/Azure-Kinect-Sensor-SDK/include/k4arecord/ /usr/include/
cp -r /home/Azure-Kinect-Sensor-SDK/include/k4arecord/ /usr/include/

cp $PKG_LIST_DIR/kinect_include/CMakeLists.txt /home/Azure-Kinect-Samples/body-tracking-samples/simple_3d_viewer/CMakeLists.txt

cd /home/Azure-Kinect-Samples &&\
   mkdir -p build && \
   cd build &&\
   cmake .. -GNinja &&\
   ninja

cp -r /install/libk4abt1.0/usr/bin/dnn_model_2_0.onnx  /usr/bin/
