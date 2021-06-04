# Copyright 2020
# Ty Nguyen 
# tynguyen.tech@gmail.com
# This docker file enables you to build purely from ubuntu without using nvidia/cuda image.
# #==========================================================================
# For the following ARG variables, an default value is given to use if not set through --build_arg  i.e. docker build --build_arg base_docker_img_name=nvidia/cuda ....

ARG base_docker_img_name="ubuntu" 
ARG base_docker_img_tag="18.04"

FROM ${base_docker_img_name}:${base_docker_img_tag}
#FROM nvidia/cuda:10.2-devel-ubuntu18.04


RUN apt-get update

# Install timezone using script
# NOTE: make sure that file install_timezone.sh is executable
ADD install_timezone.sh /install_timezone.sh
RUN /install_timezone.sh
#RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Add username and add to sudoers group to install tensorflow ...
ARG user_name=tynguyen
ARG user_id=1000
ARG g_id=1000
## Replace 1012 with your user / group id of the machine on which docker is installed
# To find this, use: $id -u  and $id -g 
RUN apt-get install sudo
RUN export uid=$user_id gid=$g_id && \
    mkdir -p /home/$user_name && \
    echo "$user_name:x:${uid}:${gid}:$user_name,,,:/home/$user_name:/bin/bash" >> /etc/passwd && \
    echo "$user_name:x:${uid}:" >> /etc/group && \
    echo "$user_name ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user_name && \
    chmod 0440 /etc/sudoers.d/$user_name && \
    chown ${uid}:${gid} -R /home/$user_name


# Use NVDIA-driver installed on the host machine
###########################################################################
# base
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.1.243
ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-1 \
    && ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# Expand PATH and LD_LIBRARY_PATH to enable CUDA usage 
RUN echo "export PATH=$PATH:/usr/local/cuda-10.1/bin" >> /home/$user_name/.bashrc
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-10.1/lib64" >> /home/$user_name/.bashrc

###########################################################################
#runtime next
ENV NCCL_VERSION 2.7.8

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-npp-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libcublas10=10.2.1.243-1 \
    libnccl2=$NCCL_VERSION-1+cuda10.1 \
    && apt-mark hold libnccl2 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas10

###########################################################################
#cudnn7 (not cudnn8) next

ENV CUDNN_VERSION 7.6.5.32

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
    && apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*


ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1"


#ENV DEBIAN_FRONTEND noninteractive

# Install object detection api dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install essential development packages
ADD install_essential_packages.sh /install_essential_packages.sh
RUN /install_essential_packages.sh

# Install python3.7
ADD install_python3.7.sh /install_python3.7.sh
RUN /install_python3.7.sh



# Install wget (to make life easier below) and editors (to allow people to edit
# the files inside the container)
RUN apt-get update && \
    apt-get install -y wget vim emacs nano tmux

# Install opencv3
ADD install_opencv3_from_pip.sh /install_opencv3_from_pip.sh
RUN /install_opencv3_from_pip.sh


USER $user_name
ENV HOME /home/$user_name

# (Optional) Configure vim
RUN mkdir -p $HOME/.vim
ADD Cfg/.vim $HOME/.vim
RUN git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
# (Optional) Configure tmux
ADD Cfg/.tmux.conf $HOME/.tmux.conf


# Copy scripts that contains useful commands i.e .bashrc, my_robot_env.sh .... 
COPY Env/.bashrc $HOME/.bashrc
RUN mkdir $HOME/Env 
COPY Env $HOME/

WORKDIR $HOME


