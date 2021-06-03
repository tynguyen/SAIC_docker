ARG BASE_URL=https://us.download.nvidia.com/tesla
ARG BASE_URL=https://us.download.nvidia.com/tesla
ARG DRIVER_VERSION
ENV DRIVER_VERSION=$DRIVER_VERSION
ARG DRIVER_BRANCH=460
ENV DRIVER_BRANCH=$DRIVER_BRANCH
ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=void

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        ca-certificates \
        curl \
        kmod \
        libc6:i386 \
        libelf-dev \
        libglvnd-dev \
        pkg-config \
        nvidia-fabricmanager-${DRIVER_BRANCH}=${DRIVER_VERSION}-1 \
        libnvidia-nscq-${DRIVER_BRANCH}=${DRIVER_VERSION}-1 && \
    rm -rf /var/lib/apt/lists/*

RUN echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ bionic main universe" > /etc/apt/sources.list && \
    echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ bionic-updates main universe" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ bionic-security main universe" >> /etc/apt/sources.list && \
    usermod -o -u 0 -g 0 _apt

RUN curl -fsSL -o /usr/local/bin/donkey https://github.com/3XX0/donkey/releases/download/v1.1.0/donkey && \
    curl -fsSL -o /usr/local/bin/extract-vmlinux https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux && \
    chmod +x /usr/local/bin/donkey /usr/local/bin/extract-vmlinux

# Install the userspace components and copy the kernel module sources.
RUN cd /tmp && \
    curl -fSsl -O $BASE_URL/$DRIVER_VERSION/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run && \
    sh NVIDIA-Linux-x86_64-$DRIVER_VERSION.run -x && \
    cd NVIDIA-Linux-x86_64-$DRIVER_VERSION* && \
    ./nvidia-installer --silent \
                       --no-kernel-module \
                       --install-compat32-libs \
                       --no-nouveau-check \
                       --no-nvidia-modprobe \
                       --no-rpms \
                       --no-backup \
                       --no-check-for-alternate-installs \
                       --no-libglx-indirect \
                       --no-install-libglvnd \
                       --x-prefix=/tmp/null \
                       --x-module-path=/tmp/null \
                       --x-library-path=/tmp/null \
                       --x-sysconfig-path=/tmp/null && \
    mkdir -p /usr/src/nvidia-$DRIVER_VERSION && \
    mv LICENSE mkprecompiled kernel /usr/src/nvidia-$DRIVER_VERSION && \
    sed '9,${/^\(kernel\|LICENSE\)/!d}' .manifest > /usr/src/nvidia-$DRIVER_VERSION/.manifest && \
    rm -rf /tmp/*

COPY nvidia-driver /usr/local/bin



