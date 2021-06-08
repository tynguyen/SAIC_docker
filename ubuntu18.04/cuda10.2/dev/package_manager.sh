# NOTE: do not use '.' before any script
# i.e: 
# $PKG_LIST_DIR/install_pytorch1.8.sh
echo "Installation script files found in $PKG_LIST_DIR:"
ls $PKG_LIST_DIR

# Make sure python3.7 is the default python3
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.7 2

# Install Opencv4 Python3.6 from source
$PKG_LIST_DIR/install_opencv4_python3.6_from_source.sh

# Install pytorch1.8 which is compatible with CUDA10.2
$PKG_LIST_DIR/install_pytorch1.8.sh

# Install opencv4.2 which is compatible with CUDA10.2
$PKG_LIST_DIR/install_opencv3_from_pip.sh
