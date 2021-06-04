# NOTE: do not use '.' before any script
# i.e: 
# $PKG_LIST_DIR/install_pytorch1.8.sh
echo "Installation script files found in $PKG_LIST_DIR:"
ls $PKG_LIST_DIR


# Install pytorch1.8 which is compatible with CUDA10.2
$PKG_LIST_DIR/install_pytorch1.8.sh
