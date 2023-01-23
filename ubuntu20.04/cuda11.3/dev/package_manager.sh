# NOTE: do not use '.' before any script
# i.e:
# $PKG_LIST_DIR/install_pytorch1.9.sh
echo "Installation script files found in $PKG_LIST_DIR:"
ls $PKG_LIST_DIR

# Install Opencv4 Python3.10 from source
$PKG_LIST_DIR/install_opencv4_cuda11.3_python3.10_from_source.sh

# Install pytorch1.12.1 which is compatible with CUDA11.3
$PKG_LIST_DIR/install_pytorch1.12.sh
