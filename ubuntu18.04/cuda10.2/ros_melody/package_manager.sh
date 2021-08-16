# NOTE: do not use '.' before any script
# i.e:
# $PKG_LIST_DIR/install_pytorch1.8.sh
echo "Installation script files found in $PKG_LIST_DIR:"
ls $PKG_LIST_DIR

# Install ROS Melodic
$PKG_LIST_DIR/install_scripts_for_ros/install_ros_melodic.sh
# Create catkin_ws
$PKG_LIST_DIR/install_scripts_for_ros/create_catkin_ws.bash
# Install ROS independences
$PKG_LIST_DIR/install_scripts_for_ros/install_ros_depenences.bash

# Install NVIDIA-docker
$PKG_LIST_DIR/install_NVIDIA_docker.sh
