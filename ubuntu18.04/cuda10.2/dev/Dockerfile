FROM saic/ubuntu18.04:base-cuda10.2-cudnn8

# For the following ARG variables, an default value is given to use if not set through --build_arg  i.e. docker build --build_arg base_docker_img_name=nvidia/cuda ....

ARG base_docker_img_name="saic/ubuntu18.04" 
ARG base_docker_img_tag="base-cuda10.2-cudnn8"

FROM ${base_docker_img_name}:${base_docker_img_tag}


RUN apt-get update

# Add username and add to sudoers group to install tensorflow ...
ARG user_name=saic
ARG user_id=1000
ARG g_id=1000


ENV DEBIAN_FRONTEND noninteractive
