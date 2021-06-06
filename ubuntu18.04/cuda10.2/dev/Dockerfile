# For the following ARG variables, an default value is given to use if not set through --build_arg  i.e. docker build --build_arg base_docker_img_name=nvidia/cuda ....
ARG base_docker_img_name="saic/ubuntu18.04" 
ARG base_docker_img_tag="base-cuda10.2-cudnn8"

FROM ${base_docker_img_name}:${base_docker_img_tag}

ENV DEBIAN_FRONTEND noninteractive

# Switch to root user to install packages that might require a sudoer
USER root
RUN apt-get update


# Add an user. By default, user name is given from build_img.sh
ARG user_name=saic
ARG user_id=1000
ARG g_id=1000

# To find user id on your host machine, use: $id -u  and $id -g 
RUN apt-get install sudo
RUN export uid=$user_id gid=$g_id && \
    mkdir -p /home/$user_name && \
    echo "$user_name:x:${uid}:${gid}:$user_name,,,:/home/$user_name:/bin/bash" >> /etc/passwd && \
    echo "$user_name:x:${uid}:" >> /etc/group && \
    echo "$user_name ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user_name && \
    chmod 0440 /etc/sudoers.d/$user_name && \
    chown ${uid}:${gid} -R /home/$user_name

#----------------------------------------------#
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
RUN chmod +x $PKG_LIST_DIR/* 
COPY $pkg_manager_file $PKG_MANGER_FILE 
RUN chmod +x $PKG_MANGER_FILE 
RUN $PKG_MANGER_FILE 
RUN rm $PKG_MANGER_FILE
RUN rm -rf $PKG_LIST_DIR

# Install pytorch1.8 which is compatible with CUDA10.2
#ADD $sh_dir/install_pytorch1.8.sh /install_pytorch1.8.sh
#RUN chmod +x /install_pytorch1.8.sh
#RUN /install_pytorch1.8.sh
#RUN rm /install_pytorch1.8.sh


#----------------------------------------------#
# Switch to your user name. Not be abl to install any that requires SUDO 
USER $user_name
ENV HOME /home/$user_name

# (Optional) Configure .bashrc, vim, tmux
ARG cfg_dir="cfg_scripts"
ENV CFG_DIR=$cfg_dir
COPY $cfg_dir/.bashrc $HOME/.bashrc
ENV CFG_DIR=$HOME/Env
COPY $cfg_dir $CFG_DIR

# Install vim
RUN mkdir -p $HOME/.vim
RUN rm -rf $HOME/.vim/*
COPY $CFG_DIR/.vim $HOME/.vim
RUN git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall
RUN cd $HOME/.vim/bundle/YouCompleteMe && python3 install.py
RUN cd $HOME/.vim/bundle/YouCompleteMe && python3 install.py

# (Optional) Configure tmux
COPY $CFG_DIR/.tmux.conf $HOME/.tmux.conf

# Default repository after logging in
WORKDIR $HOME
