# The current version is not ready for non-gui installation yet
CUDA_VERSION="cuda10.2"
CUDNN_VERSION="8.2.0.53"

# Install cuda
cd $HOME
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
chmod +x cuda_10.2.89_440.33.01_linux.run
./cuda_10.2.89_440.33.01_linux.run


echo "Cuda version: $CUDA_VERSION"
apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8=${CUDNN_VERSION}-1+${CUDA_VERSION} \
    libcudnn8-dev=${CUDNN_VERSION}-1+${CUDA_VERSION} \
    && apt-mark hold libcudnn8 && \
    rm -rf /var/lib/apt/lists/*

cd $HOME
rm