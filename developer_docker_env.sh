# Dev docker image that you want to build now
DEV_DOCKER_IMG_NAME="tynguyen/ubuntu20.04"
DEV_DOCKER_IMG_TAG="dev-cuda11.3-cudnn8"

# Base docker image that you want to build upon on
export BASE_DOCKER_IMG_NAME="tynguyen/ubuntu20.04"
export BASE_DOCKER_IMG_TAG="base-cuda11.3-cudnn8"


: ' Name the docker image that you want to build i.e: $DOCKER_IMG_NAME:$DOCKER_IMG_TAG
If you do not change anything, by default, your docker image name will be
tynguyen/ubuntu18.04:<your user name>_cuda11.3-cudnn8
'
user_name=$(whoami)

#TODO:
# If you want to build the base docker image: comment the first two lines and uncomment the last two lines.
# If you want to build the dev docker image: do not need to change anything
# Don't forget to source this file after making the change.
export DOCKER_IMG_NAME=$DEV_DOCKER_IMG_NAME
export DOCKER_IMG_TAG=$DEV_DOCKER_IMG_TAG
#export DOCKER_IMG_NAME=$BASE_DOCKER_IMG_NAME
#export DOCKER_IMG_TAG=$BASE_DOCKER_IMG_TAG

export CONTAINER_NAME="${user_name}-${DOCKER_IMG_TAG}"
