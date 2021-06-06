# Copyright 2020
# Ty Nguyen 
# tynguyen.tech@gmail.com
# #==========================================================================
# For the following ARG variables, an default value is given to use if not set through --build_arg  i.e. docker build --build_arg base_docker_img_name=nvidia/cuda ....

ARG base_docker_img_name="nvidia/cuda" 
ARG base_docker_img_tag="10.2-devel-ubuntu18.04"

FROM ${base_docker_img_name}:${base_docker_img_tag}
#FROM nvidia/cuda:10.2-devel-ubuntu18.04

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
ENV user_name saicny
ENV user_id 0
ENV g_id 0

# To find user id on your host machine, use: $id -u  and $id -g 
RUN apt-get install sudo
RUN export uid=$user_id gid=$g_id && \
    mkdir -p /home/$user_name && \
    echo "$user_name:x:${uid}:${gid}:$user_name,,,:/home/$user_name:/bin/bash" >> /etc/passwd && \
    echo "$user_name:x:${uid}:" >> /etc/group && \
    echo "$user_name ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user_name && \
    chmod 0440 /etc/sudoers.d/$user_name && \
    chown ${uid}:${gid} -R /home/$user_name

# Install cudnn
# NOTE: in order to make the following ENV works, the following lines must be given after FROM ...
ENV CUDA_VERSION="cuda10.2"
ENV CUDNN_VERSION="8.2.0.53"

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

#TODO: change this cuda10.2 according to the CUDA version that you want to use
RUN echo "Cuda version: $CUDA_VERSION"
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8=$CUDNN_VERSION-1+$CUDA_VERSION \
    libcudnn8-dev=$CUDNN_VERSION-1+$CUDA_VERSION \
    && apt-mark hold libcudnn8 && \
    rm -rf /var/lib/apt/lists/*


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
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
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
USER $user_name
ENV HOME /home/$user_name

# (Optional) Configure .bashrc, vim, tmux
ARG cfg_dir="cfg_scripts"
COPY $cfg_dir/.bashrc $HOME/.bashrc
ENV CFG_DIR=$HOME/Env
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


