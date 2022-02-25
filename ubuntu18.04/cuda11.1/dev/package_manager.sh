# NOTE: do not use '.' before any script
# i.e:
# $PKG_LIST_DIR/install_pytorch1.9.sh
echo "Installation script files found in $PKG_LIST_DIR:"
ls $PKG_LIST_DIR

# # Make sure python3.7 is the default python3
# update-alternatives --install /usr/bin/python3 python3 $(which python3.6) 1
# update-alternatives --install /usr/bin/python3 python3 $(which python3.7) 2

# Install Opencv4 Python3.7 from source
$PKG_LIST_DIR/install_opencv4_cuda11.1_python3.7_from_source.sh

# Install pytorch1.9 which is compatible with CUDA11.1
$PKG_LIST_DIR/install_pytorch1.9.sh