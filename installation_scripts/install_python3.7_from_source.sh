apt update 
apt upgrade
apt-get install -y wget build-essential checkinstall
apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev \
      libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz 
tar -xvf Python-3.7.9.tgz && cd Python-3.7.9
./configure --enable-optimizations --enable-shared 
make -j 4
make altinstall
