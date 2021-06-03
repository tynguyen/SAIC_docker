# Docker
My repo for docker management
tynguyen@seas.upenn.edu 

# Updates
- [ ] [updated June 1st 2021] more flexible on cudnn version and cuda version. New build_img.sh script enables to select cuda version as well as cudnn version. 
- [ ] [updated June 2st 2021] move away .bashrc, .tmux.conf, my_docker_env.sh from the host machine by giving them directly 

# Structure 
Dockerfiles are organized in an hierarchical way as followings:
ubuntu<version>
    cuda<version>
        base
            Dockerfile
            installation_file1
            installation_file2
        dev
            Dockerfile
            some_installation_file1
            some_installation_file2

To build your own docker image with new packages, all you need is to create installation files, put them into the `dev` subfolder and run
```
bash build_img.sh ubuntu<version>/cuda<version>/dev
```
Note: there should be NO `/` at the end of the given directory in the above example. 

## Base image: saic/ubuntu1804:cuda12.0
Based on nvidia/cuda:10.2-devel-ubuntu18.04
- [x] ubuntu18.04
- [x] cuda10.2
- [x] cudnn8 
- [x] python3.7
- [x] Opencv3 python3.7 via pip :-( 

(Optional) In order to build the base image, you need to install some prerequisites packages on the host machine. 
```
bash host_prerequisites_installation.sh
```

## Dev images


## (Optional) Create a new image from a base image
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
touch install_pytorch.sh
chmod +x install_pytorch.sh
``` 
Remove all "sudo" in the install_pytorch.sh. Then, in the Dockerfile, include

```
ADD install_pytorch.sh /install_pytorch.sh
RUN /install_pytorch.sh
```

## Note
Make sure to set every scripts "install....sh" runable
i.e.
```
chmod +x install_python3.7.sh
```


# Create a container 
## Set the docker image and the name of the container by modifying: 
```
DOCKER_IMG_NAME="tynguyen_base_ubuntu1804_cuda10.0_docker:latest"
CONTAINER_NAME="tynguyen_base"
```
in my_docker_env.sh 
Then, run this shell script
```
bash my_docker_env.sh
```
Note: you need to run this my_docker_env.sh everytime you open a new terminal. To avoid this step, one way is to copy this file to $HOME/Env/my_docker_env.sh and in the $HOME/.bashrc file, add the following line
```
source ~/Env/my_docker_env.sh
```


## Build the Image if Not Exist Yet
```
bash build_img.sh <directory to the image dockerfile>
```
i.e 
```
bash build_img.sh tynguyen_base_ubuntu1804_cuda_10.0_docker 
```

## Create the container 
Name of the image and container should be already set in my_docker_env.sh file
```
bash create_container.sh <docker image> [-ws <List of folders that want to share with the container> ]
```
For example: 
```
bash create_container nvidia/ubuntu:latest ~/github_ws ~/bags

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
