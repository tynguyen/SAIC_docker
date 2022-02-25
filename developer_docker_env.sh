# Base docker image that you want to build upon on
export BASE_DOCKER_IMG_NAME="tynguyen/ubuntu18.04"
export BASE_DOCKER_IMG_TAG="base-cuda11.1-cudnn8"

: ' Name the docker image that you want to build i.e: $DOCKER_IMG_NAME:$DOCKER_IMG_TAG
If you do not change anything, by default, your docker image name will be
tynguyen/ubuntu18.04:<your user name>_cuda11.1-cudnn8
'
user_name=$(whoami)

export DOCKER_IMG_NAME=$BASE_DOCKER_IMG_NAME
DEV_DOCKER_IMG_TAG="dev-cuda11.1-cudnn8"
# export DOCKER_IMG_TAG=$BASE_DOCKER_IMG_TAG
export DOCKER_IMG_TAG=$DEV_DOCKER_IMG_TAG
export CONTAINER_NAME="${user_name}-${DOCKER_IMG_TAG}"
