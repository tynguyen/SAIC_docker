# NOTE: do not use '.' before any script
# i.e:
# $PKG_LIST_DIR/install_pytorch1.8.sh
echo "Installation script files found in $PKG_LIST_DIR:"
ls $PKG_LIST_DIR


# Install essential development packages
$PKG_LIST_DIR/install_essential_packages.sh

# Install python3.10 & its packages
# $PKG_LIST_DIR/install_python3.10.sh
$PKG_LIST_DIR/install_python3.10_from_source.sh
