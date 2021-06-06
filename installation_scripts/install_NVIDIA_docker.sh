#######################################################################
##                       install nvidia docker                       ##
#######################################################################

apt-get update && apt-get install -y --no-install-recommends \
    libxau-dev \
    libxdmcp-dev \
    libxcb1-dev \
    libxext-dev \
    libx11-dev && \
    rm -rf /var/lib/apt/lists/*

# install GLX-Gears
apt update && apt install -y --no-install-recommends \
    mesa-utils x11-apps \
    && rm -rf /var/lib/apt/lists/*
