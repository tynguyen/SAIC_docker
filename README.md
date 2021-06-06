# EZ-Docker
@Brief: My repo for docker management. 
My goal is to create a clean, usablle docker management system that can bring seamless experience to Ubuntu users. 
I focus on the following points, 
* Reusablity: users can update ubuntu versions, CUDA versions, cudnn versions, and other packages versions. Only need to create an installation script once for each package which can be used to install on different docker images. 
* Versality: switching between different docker image is easy
* User-friendliness: users should be able to execute common tasks such as create a container, log into a container, 
delete a container, access shared data with the host machine WITHOUT learning docker commands. 
* Ease to manage: developers should find it easy to keep track of software packages that are already installed in each docker image

@Maintainer: tynguyen@seas.upenn.edu 

# Updates
- [ ] [updated June 1st 2021] more flexible on cudnn version and cuda version. New build_img.sh script enables to select cuda version as well as cudnn version. 
- [ ] [updated June 2st 2021] move away .bashrc, .tmux.conf, my_docker_env.sh from the host machine by giving them directly 

# Structure 
Dockerfiles are organized in an hierarchical way as followings:
* installation_scripts : contain all scripts, each of which installs a specific package. 
    * install_<pkg_name1>.sh
    * install_<pkg_name2>.sh
    * ... 
* ubuntu<version> : contain all Dockerfiles for a specific Ubuntu version
    * cuda<version> : contain all Dockerfiles for a specific CUDA version
        * base : contain the Dockerfiles for the base image
            * Dockerfile
            * package_manager.sh : lists all (optional) package installation scripts for this image, obtained from installatio_scrpts
        * dev : contain the Dockerfile the dev image which is built upon on the base image 
            * Dockerfile
            * package_manager.sh : lists all (optional) package installation scripts for this image, obtained from installatio_scrpts

To build your own docker image with new packages, all you need is to create installation files, put them into the `installation_scripts` folder, add one line to the package_manager.sh and run
```
bash build_img.sh ubuntu<version>/cuda<version>/dev/Dockerfile
```

## Base image: saic/ubuntu1804:cuda12.0
Based on nvidia/cuda:10.2-devel-ubuntu18.04
- [x] ubuntu18.04
- [x] cuda10.2
- [x] cudnn8 
- [x] python3.6.9
- [x] cmake 3.20.3 
- [x] vim 8.2 
- [x] Opencv3 python3.7 via pip :-( 
- [x] YouCompleteMe for VIM. Not work yet! 

(Optional) In order to build the base image, you need to install some prerequisites packages on the host machine. 
```
bash host_prerequisites_installation.sh
```

# Installation
First, download the repo
```
git clone --recursive-submodules https://github.com/tynguyen/SAIC_docker.git
cd SAIC_docker
```

Set the docker image and the name of the container by modifying, for example:
```
DOCKER_IMG_NAME="tynguyen_base_ubuntu1804_cuda10.0_docker:latest"
CONTAINER_NAME="tynguyen_base"
```
in my_docker_env.sh 

Then, run this shell script
```
source my_docker_env.sh
```
Note: you need to run this my_docker_env.sh everytime you open a new terminal. To avoid this step, one way is to copy this file to $HOME/Env/my_docker_env.sh and in the $HOME/.bashrc file, add the following line
```
source ~/Env/my_docker_env.sh
```

# Usage 
By default, you will be using a docker image that is already created. Its name is given in `my_docker_env.sh`. 
Follow the a few steps below to create a container which is basically an Ubuntu machine of your own and run it. 
## Create the container 
Name of the image and container should be already set in my_docker_env.sh file
```
*Prerequisites: run 
         source my_docker_env.sh
*Syntax: 
         bash $(basename $0) [Options]
*Options: 
         -h: display Help
         -i <docker image with tag>: docker image name i.e: docker:latest. This will overwrite DOCKER_IMG_NAME and DOCKER_IMG_TAG
         -v <absolute path to the directory on the host machine>: share this path with the docker container 
         -n <name>: name of the docker container you want to creater  
         -u <user name>: user name in the docker container. Shared directory will be stored to /home/<user name>/
         -p <port mapping>: i.e: 0.0.0.0:7008:7008 
```
For example: 
```
bash create_container.sh -i saic/ubuntu18.04:base-cuda10.2-cudnn8 -v ~/github_ws -v ~/bags

```
In this example, the created container will share two folders: ~/github_ws and ~/bags with the host machine. 

# Use a container
Once a container is created, the following scripts are used to easily manage the container.
```
run_container.sh: start the container (different from creating the container). This is used in case the  container is already there (check by $docker container ls -a)
stop_container.sh: stop the container 
rm_container.sh : remove the container
```
These scripts refer to $CONTAINER_NAME set in my_docker_env.sh 

---
# Advanced 
## Create a new image from a base image
Create a folder that contains our Dockefile
i.e. DOCKER_FILE_FOLDER=dockerfile_path, then 
```
source my_docker_env.sh
cd $DOCKER_FILE_PATH
touch Dockerfile
```
To make it easier to manage which packages installed in the image, for each package supposed to be intalled in the image, one should create a script
i.e
```
touch SAIC_docker/installation_scripts/install_pytorch.sh
``` 
Remove all "sudo" in the install_pytorch.sh. Then, make a package_manager.sh file in the same repo with Dockerfile, and write, for example:
```
$PKG_LIST_DIR/install_pytorch.sh
```

## Note
Make sure to set every scripts "install....sh" runable
i.e.
```
chmod +x install_python3.7.sh
```
