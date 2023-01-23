# Copyright 2023
# Ty Nguyen
# tynguyen.tech@gmail.com
# #==========================================================================
# For the following ARG variables, an default value is given to use if not set through --build_arg  i.e. docker build --build_arg base_docker_img_name=nvidia/cuda ....

# For some unknown reasons, the following commands do not always work:
# ARG base_docker_img_name="nvidia/cuda"
# ARG base_docker_img_tag="11.1.1-cudnn8-devel-ubuntu18.04"
# FROM ${base_docker_img_name}:${base_docker_img_tag}

# If they do not work, use the following command instead
FROM nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get update && apt install -y software-properties-common

#---------------------------------------#
# Install packages
# Directory to installation files
ARG pkg_list_dir="" > dir to the list of packages
ARG pkg_manager_file="" > the pkg manager file (.sh) which runs all instalation scripts

# Copy all installation script files to a folder
ENV PKG_LIST_DIR="/installation_scripts"
ENV PKG_MANGER_FILE="/package_manager.sh"
# We need to run only once for every package installation
RUN echo "PKG_MANAGER_DIR: $PKG_MANAGER_FILE"
RUN echo "PKG_LIST_DIR: $PKG_LIST_DIR"
COPY $pkg_list_dir $PKG_LIST_DIR
COPY $pkg_manager_file $PKG_MANGER_FILE
RUN chmod +x $PKG_LIST_DIR/*
RUN chmod +x $PKG_MANGER_FILE

# We install timezone first. Other packages will be installed later
RUN $PKG_LIST_DIR/install_timezone.sh

# Add username and add to sudoers group. saicny will be one default user
ARG USER_NAME=developer > Note: do not use ENV because it will be kept to next layers
ARG USER_ID=0
ARG G_ID=0

# To find user id on your host machine, use: $id -u  and $id -g
RUN apt-get install sudo
RUN export uid=$USER_ID gid=$G_ID && \
    mkdir -p /home/$USER_NAME && \
    echo "$USER_NAME:x:${uid}:${gid}:$USER_NAME,,,:/home/$USER_NAME:/bin/bash" >> /etc/passwd && \
    echo "$USER_NAME:x:${uid}:" >> /etc/group && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER_NAME && \
    chmod 0440 /etc/sudoers.d/$USER_NAME && \
    chown ${uid}:${gid} -R /home/$USER_NAME

# Install cudnn if the base image has not had cudnn installed yet.
# NOTE: in order to make the following ENV works, the following lines must be given after FROM ...
# ENV CUDA_VERSION="cuda11.1.1"
# ENV CUDNN_VERSION="8.2.1"

# LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

# #TODO: change this cuda10.2 according to the CUDA version that you want to use
# RUN echo "Cuda version: $CUDA_VERSION"
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     libcudnn8=$CUDNN_VERSION-1+$CUDA_VERSION \
#     libcudnn8-dev=$CUDNN_VERSION-1+$CUDA_VERSION \
#     && apt-mark hold libcudnn8 && \
#     rm -rf /var/lib/apt/lists/*


# Install ubuntu essential dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils


# Install wget (to make life easier below) and editors (to allow people to edit
# the files inside the container)
RUN apt-get update && \
    apt-get install -y wget emacs nano tmux


#-----------------------------#
# (Optional) Other package installation using the package manager file
RUN $PKG_MANGER_FILE

# Cleaning script files
RUN $PKG_MANGER_FILE
RUN rm $PKG_MANGER_FILE
RUN rm -rf $PKG_LIST_DIR


# Install g++8
RUN apt-get install -y g++-8
#-----------------------------#

# Install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.3/cmake-3.20.3.tar.gz
RUN apt-get install libssl-dev
RUN tar -xvf cmake-3.20.3.tar.gz
RUN cd cmake-3.20.3 && ./bootstrap && make && make install

# Install vim8.2 which is necessary for YouCompleteMe (vim needs to be >= 8.1)
RUN apt-get update
RUN add-apt-repository ppa:jonathonf/vim -y
RUN apt-get update
RUN apt-get install -y vim
RUN apt-get install -y vim-gtk3 vim-nox


# Switch to the user
USER $USER_NAME
ARG HOME=/home/$USER_NAME

# (Optional) Configure .bashrc, vim, tmux
ARG cfg_dir="cfg_scripts"
COPY $cfg_dir/.bashrc $HOME/.bashrc
ARG CFG_DIR=$HOME/Env
COPY $cfg_dir $CFG_DIR

RUN mkdir -p $HOME/.vim
RUN rm -rf $HOME/.vim/*
COPY $cfg_dir/.vim $HOME/.vim
COPY $cfg_dir/.vim/colors $HOME/.vim/colors
RUN git clone --recurse-submodules https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

# Currently, the following lines have to be run manually upon loggin into the docker
#RUN vim +PlugInstall +qall
#RUN cd $HOME/.vim/bundle/YouCompleteMe && python3 install.py -y
#RUN cd $HOME/.vim/bundle/YouCompleteMe && python3 install.py -y

# (Optional) Configure tmux
COPY $cfg_dir/.tmux.conf $HOME/.tmux.conf



# Default repository after logging in
WORKDIR $HOME
