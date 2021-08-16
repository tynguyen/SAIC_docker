#!/bin/bash
set -e
# get UBUNTU_CODENAME, ROS_DISTRO, REPO_DIR, CATKIN_DIR
source $PKG_LIST_DIR/install_scripts_for_ros/identify_env.bash

source /opt/ros/$ROS_DISTRO/setup.bash

main()
{
    install_catkin_tools
    create_catkin_ws
}

install_catkin_tools()
{
    # Check if already installed
    if type catkin > /dev/null 2>&1; then
        echo "Catkin tools is already installed"
    else
        echo "Installing catkin tools ..."
        sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
        wget -qO - http://packages.ros.org/ros.key | apt-key add -
        apt-get -qq update
        apt-get -qq install python-catkin-tools > /dev/null
        echo "Catkin tools installed successfully."
    fi
}

create_catkin_ws()
{
    # Check if workspace exists
    if [ -e "$CATKIN_DIR/.catkin_workspace" ] || [ -d "$CATKIN_DIR/.catkin_tools" ]; then
        echo "Catkin workspace detected at ~/catkin_ws"
    else
        echo "Creating catkin workspace in $HOME/catkin_ws ..."
        source /opt/ros/$ROS_DISTRO/setup.bash
        mkdir -p "$HOME/catkin_ws/src"
        cd "$HOME/catkin_ws"
        catkin init > /dev/null
        catkin_make
        echo "Catkin workspace created successfully."
    fi
}

main