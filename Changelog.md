# Change Log
All major changes are listed here.

# Feb 22nd, 2022
## Added
- [x] Attempted to install `zsh` on `my_docker` image. Does not work yet. The following files were created
```
my_docker/user_specific_package_manager.sh
installation_scripts/install_zsh.sh
```
- [x] Install Opencv4 on the dev docker image
- [x] Install Pytorch1.9 on the dev docker image

## Changed
- [x] Install python3.7 from source for base docker image
- [x] Modify OpenCV installation scripts to make it work regardless of where python is installed for python3.7
- [x] Modify OpenCV installation scripts to make it work regardless of where python is installed for python3.6
