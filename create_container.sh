#!/usr/bin/env bash

# Runs a docker container with the image created by build.bash
# Requires:
#   docker
#   nvidia-docker
#   an X server

HELP()
{
  # Display help
  echo "*Prerequisites: run "
  echo "         source my_docker_env.sh"
  echo "*Syntax: "
  echo "         bash $(basename $0) [Options]"
  echo "*Options:" 
  echo "         -h: display Help"
  echo "         -i <docker image with tag>: docker image name i.e: docker:latest. This will overwrite DOCKER_IMG_NAME and DOCKER_IMG_TAG"
  echo "         -v <absolute path to the directory on the host machine>: share this path with the docker container "  
  echo "         -n <name>: name of the docker container you want to creater"  
  echo "         -u <user name>: user name in the docker container. Shared directory will be stored to /home/<user name>/"
  echo "         -p <port mapping>: i.e: 0.0.0.0:7008: 7008" 

}

# Default user name
DOCKER_USER=$(whoami)

# Default port mapping 
PORT_OPTS=0.0.0.0:7008:7008

# Default docker image name given from $DOCKER_IMG_NAME
IMG=$DOCKER_IMG_NAME:$DOCKER_IMG_TAG


# Parse arguments
# "i:", "v:", "n:" mean that these arg needs an additional argument
# "h" means that no need an additional argument
while getopts "hi:v:n:p:u" flag
do
  case "${flag}"  in 
    h) # display Help
      HELP 
      exit;;
    i) IMG=${OPTARG};; 
    v) WS_DIR=${OPTARG} 
      WS_DIRNAME=$(basename $WS_DIR)
      echo ">> Sharing Workspace: $WS_DIR"
      DOCKER_OPTS="$DOCKER_OPTS -v $WS_DIR:/home/$DOCKER_USER/$WS_DIRNAME:rw";;
    n) CONTAINER_NAME=${OPTARG};; 
    u) DOCKER_USER=${OPTARG};; 
    p) PORT_OPTS=${OPTARG};; 
    \?) # incorrect option
      echo "Error: Invalid option."
      echo "run bash $(basename $0) -h to learn more."
      exit;;
    esac
done 



# Make sure processes in the container can connect to the x server
# Necessary so gazebo can create a context for OpenGL rendering (even headless)
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# Share your vim settings.
#VIMRC=$HOME/.vim
#DOCKER_OPTS="$DOCKER_OPTS -v $VIMRC:/home/$DOCKER_USER/.vim:rw"


## Share your bash file
#BASH_FILE=$HOME/.bashrc
#if [ -f $BASH_FILE ]
#then
#  DOCKER_OPTS="$DOCKER_OPTS -v $BASH_FILE:/home/$DOCKER_USER/.bashrc:rw"
#fi


# Share the github workspace 
#GITHUB_WS=$HOME/github_ws
#DOCKER_OPTS="$DOCKER_OPTS -v $GITHUB_WS:/home/$DOCKER_USER/github_ws:rw"


echo ">> List of options given: $DOCKER_OPTS"

# Mount extra volumes if needed.
# E.g.:
# -v "/opt/sublime_text:/opt/sublime_text" \

#--rm will remove the container after exitting

# In order to enable NVIDIA-driver use within a container, you need either
# - use nvidia-docker (install nvidia-docker-tool)
# - Or put a flag '--runtime nvidia' after 'docker run'

echo "----------------------------------"
echo ">> Creating container ${CONTAINER_NAME} from docker $IMG ...."
xhost +
nvidia-docker &> /dev/null
if [ $? -ne 0 ]; then
  docker run -it --gpus all\
    --name=$CONTAINER_NAME \
    -p $PORT_OPTS \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e XAUTHORITY=$XAUTH \
    -v "$XAUTH:$XAUTH" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix" \
    -e "LIBGL_ALWAYS_INDIRECT=" \
    -e "LIBGL_ALWAYS_SOFTWARE=1" \
    -v /etc/group:/etc/group:ro \
    -v /etc/passwd:/etc/passwd:ro \
    --group-add $(getent group audio | cut -d: -f3) \ # audio
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \ # audio
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \ # audio
    -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \ # audio
    -v "/etc/localtime:/etc/localtime:ro" \ # Time sync
    -v "/etc/timezone:/etc/timezone:ro" \ # Time sync
    --device /dev/snd \ # sound
    -v "/dev/input:/dev/input" \
    --privileged \
    --security-opt seccomp=unconfined \
    $DOCKER_OPTS \
    $IMG	\
    bash
else
  docker run -it --gpus all\
    --name=$CONTAINER_NAME \
    -p $PORT_OPTS \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e XAUTHORITY=$XAUTH \
    -v "$XAUTH:$XAUTH" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix" \
    -e "LIBGL_ALWAYS_INDIRECT=" \
    -e "LIBGL_ALWAYS_SOFTWARE=1" \
    -v /etc/group:/etc/group:ro \
    -v /etc/passwd:/etc/passwd:ro \
    --group-add $(getent group audio | cut -d: -f3) \ # audio
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \ # audio
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \ # audio
    -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \ # audio
    -v "/etc/localtime:/etc/localtime:ro" \
    -v "/etc/timezone:/etc/timezone:ro" \
    --device /dev/snd \
    -v "/dev/input:/dev/input" \
    --privileged \
    --runtime nvidia\
    --security-opt seccomp=unconfined \
    $DOCKER_OPTS \
    $IMG	\
    bash
fi
echo "----------------------------------"

