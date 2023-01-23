# Install pip for the default python3 (might be python3.6)
# This step needs to be done before installing an upgraded version of python. Otherwise, pip will not work for the upgraded version.
apt-get install -y python3-pip

apt update -y
apt upgrade -y
apt-get install -y wget build-essential checkinstall
apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev \
      libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

wget https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tgz
tar -xf Python-3.10.*.tgz && cd Python-3.10.*/
./configure --enable-optimizations --enable-shared
make -j $(nproc)

sudo make altinstall
python3.10 --version

# To enable calling python3.10
ldconfig /usr/local/lib

# Install pip for python3.10
python3.10 -m pip install pip
echo "-------------------------------"
echo $(which python3)
# Install essential python packages
python3.10 -m pip install Cython && \
python3.10 -m pip install contextlib2 && \
python3.10 -m pip install pillow && \
python3.10 -m pip install lxml && \
python3.10 -m pip install jupyter && \
python3.10 -m pip install matplotlib && \
python3.10 -m pip install numpy


apt install python3-pip
pip install module-name
pip install beautifulsoup4