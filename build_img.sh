#!/usr/bin/env bash
```
#  Usage: bash build_img.sh <folder_to_the_Docker_file> <name> <tag>

#  The created docker image will have the name + tag: image_name:tag_name
#  i.e: ubuntu1804/cuda10.2:latest

```
# Builds a Docker image.
# Define user name for the docker container
# This may not work if an user belongs to multiple groups. If it is the case, manually input
user_name=$(whoami)
user_id=$(id -u)
#g_id=$(id -g)
g_id=$user_id

if [ $# -eq 0 ]
then
    echo "Usage: $0 directory-name docker-image-name docker-tag-name" 
    echo "Or: $0 directory-name docker-image-name" 
    echo "Or: $0 directory-name" 
    exit 1
fi


# get path to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "[WARNING] Note: remove '/' at the end of the given directory!"

if [ ! -d $DIR/$1 ]
then
  echo "[ERROR] Directory to the Dockerfile must be in the same repo with this script"
  echo "What you've given: $DIR/$1 not exists!"
  exit 2
fi

if [ -n "$2" ]
then
  image_name=$(basename $2)
  echo "Given a docker name: ${image_name}"
else
  echo "Has not given a docker name!"
  if [ -n "${DOCKER_IMG_NAME}" ]
  then
    image_name=${DOCKER_IMG_NAME}
    echo "Use the default docker name given in DOCKER_IMG_NAME: ${image_name}"
  else
    echo "The default docker name given in DOCKER_IMG_NAME is (empty) ${DOCKER_IMG_NAME}! Existing..."
    exit 1
  fi
fi  


if [ -n "$3" ]
then
  tag_name=$(basename $2)
  echo "Given a tag for the docker: ${tag_name}"
else
  echo "Has not given the tag for the docker name!"
  if [ -n "${DOCKER_IMG_TAG}" ]
  then
    tag_name=${DOCKER_IMG_TAG}
    echo "Use the default docker tag given in DOCKER_IMG_TAG: ${tag_name}"
  else
    echo "The default docker tag given in DOCKER_IMG_TAG is empty! Use latest as default and continuing ..." 
  fi
fi  


echo "Dir: $DIR"
echo "Image name: $image_name"
echo "group id: $g_id"
echo "user_id: $user_id"

#image_plus_tag=$image_name:$(date +%Y_%b_%d_%H%M)
image_plus_tag=$image_name:$tag_name

echo "------------------------------"

# There is an option to use a specific base image.
if [ -n "${BASE_DOCKER_IMG_NAME}" ]
then 
  if [ -n "${BASE_DOCKER_IMG_TAG}" ]
    then
    echo "Building a Docker using the base image: ${BASE_DOCKER_IMG_NAME}:${BASE_DOCKER_IMG_TAG}"
  else 
    echo "Base tag is not given, use latest as the tag. Base image: ${BASE_DOCKER_IMG_NAME}:latest"
    BASE_DOCKER_IMG_TAG="latest"
  fi 
  else 
    echo "Base image name is not given! Use the default one given in the Dockerfile"

fi 


if [ -n "${BASE_DOCKER_IMG_NAME}" ]
then 
  docker build --rm=true -t $image_plus_tag --build-arg user_id=$user_id \
	       --build-arg user_name=$user_name	\
	       --build-arg g_id=$g_id \
	       --build-arg cuda_version=$CUDA_VERSION\
	       --build-arg cudnn_version=$CUDNN_VERSION\
	       --build-arg base_docker_img_name=$BASE_DOCKER_IMG_NAME\
	       --build-arg base_docker_img_tag=$BASE_DOCKER_IMG_TAG\
	       $DIR/$1
else 
  docker build --rm=true -t $image_plus_tag --build-arg user_id=$user_id \
	       --build-arg user_name=$user_name	\
	       --build-arg g_id=$g_id \
	       --build-arg cuda_version=$CUDA_VERSION\
	       --build-arg cudnn_version=$CUDNN_VERSION\
	       $DIR/$1
fi
#docker tag $image_plus_tag $image_name:latest

echo "Built $image_plus_tag and tagged as $image_name:$tag_name"
