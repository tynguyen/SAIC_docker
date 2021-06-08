# Container we want to build 
user_name=$(whoami)
export DOCKER_IMG_NAME="tynguyen/saicny_ubuntu18.04"
export DOCKER_IMG_TAG="kinect-cuda10.2-cudnn8"
export CONTAINER_NAME="${user_name}_docker"  
