# NOTE: do not use '.' before any script
# i.e: 
# $PKG_LIST_DIR/install_pytorch1.8.sh
echo "Installation script files found in $PKG_LIST_DIR:"
ls $PKG_LIST_DIR

# Install NVIDIA-docker
$PKG_LIST_DIR/install_NVIDIA_docker.sh

# Install Azure kinect SDK 1.3
$PKG_LIST_DIR/install_azure_kinect_SDK1.3.sh

# Install Azure kinect body tracking 1.0
$PKG_LIST_DIR/install_azure_kinect_bodytracking1.0.sh

