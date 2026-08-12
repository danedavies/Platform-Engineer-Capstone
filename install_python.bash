sudo yum groupinstall "Development Tools" -y 
sudo yum install openssl-devel bzip2-devel libffi-devel zlib-devel wget tar -y
cd /tmp
wget https://www.python.org/ftp/python/3.11.15/Python-3.11.15.tgz
tar -xzf Python-3.11.15.tgz
cd Python-3.11.15
./configure --enable-optimizations 
make -j$(nproc) 
sudo make altinstall

