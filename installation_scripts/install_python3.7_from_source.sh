# Install pip for the default python3 (might be python3.6)
# This step needs to be done before installing an upgraded version of python. Otherwise, pip will not work for the upgraded version.
apt-get install -y python3-pip

apt update -y
apt upgrade -y
apt-get install -y wget build-essential checkinstall
apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev \
      libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz
tar -xvf Python-3.7.9.tgz && cd Python-3.7.9
./configure --enable-optimizations --enable-shared
make -j 4
make altinstall

# To enable calling python3.7
ldconfig /usr/local/lib

# Do not make python3.7 the default python since it can cause other issues with package installation when python3.6 (the Ubuntu18.04's default python version) is required.
# Make sure python3.7 is the default python3
# update-alternatives --install /usr/bin/python3 python3 $(which python3.6) 1
# update-alternatives --install /usr/bin/python3 python3 $(which python3.7) 2

# Install pip for python3.7
python3.7 -m pip install pip
echo "-------------------------------"
echo $(which python3)
# Install essential python packages
python3.7 -m pip install Cython && \
python3.7 -m pip install contextlib2 && \
python3.7 -m pip install pillow && \
python3.7 -m pip install lxml && \
python3.7 -m pip install jupyter && \
python3.7 -m pip install matplotlib && \
python3.7 -m pip install numpy
