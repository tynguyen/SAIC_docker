# Base docker container to build ours
#export BASE_DOCKER_IMG_NAME="nvidia/cuda"            
#export BASE_DOCKER_IMG_TAG="10.2-devel-ubuntu18.04"

# Container we want to build 
user_name=$(whoami)
#export DOCKER_IMG_NAME="saic/ubuntu18.04"
#export DOCKER_IMG_TAG="base-cuda10.2-cudnn8"
export DOCKER_IMG_NAME="tynguyen/saicny_ubuntu18.04"
export DOCKER_IMG_TAG="dev-cuda10.2-cudnn8"
export CONTAINER_NAME="${user_name}_docker"  
#export DOCKER_IMG_NAME="chakio/azure_kinect_ros"
#export DOCKER_IMG_TAG="latest"
