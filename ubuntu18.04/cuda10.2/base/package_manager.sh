# NOTE: do not use '.' before any script
# i.e: 
# $PKG_LIST_DIR/install_pytorch1.8.sh
echo "Installation script files found in $PKG_LIST_DIR:"
ls $PKG_LIST_DIR


# Install essential development packages
$PKG_LIST_DIR/install_essential_packages.sh 

# Install python3.7
$PKG_LIST_DIR/install_python3.7.sh
#$PKG_LIST_DIR/install_python3.7_from_source.sh

# Install python3.6
#$PKG_LIST_DIR/install_python3.6.sh

