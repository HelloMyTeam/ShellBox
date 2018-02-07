#!/bin/bash

cd `dirname $0`

# git submodule update
# check_sys(){
#     if [[ -f /etc/redhat-release ]]; then
#         release="centos"
#     elif cat /etc/issue | grep -q -E -i "debian"; then
#         release="debian"
#     elif cat /etc/issue | grep -q -E -i "ubuntu"; then
#         release="ubuntu"
#     elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
#         release="centos"
#     elif cat /proc/version | grep -q -E -i "debian"; then
#         release="debian"
#     elif cat /proc/version | grep -q -E -i "ubuntu"; then
#         release="ubuntu"
#     elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
#         release="centos"
#     fi
#     bit=`uname -m`

# }

setup_env() {
    which virtualenv
    if [[ $? != 0 ]];then
        pip install virtualenv
    fi
    if [[ ! -d .env ]];then
        virtualenv --no-site-packages -p python3 .env
    fi

    source .env/bin/activate && \
    pip3 install -r requirements.txt
}

sysOS=`uname -s`
which python3

if [[ $? != 0 ]];then
    if [ $sysOS == "Darwin" ];then
        which brew
        if [[ $? != 0 ]];then
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        brew install python3
    elif [ $sysOS == "Linux" ];then
        cd /tmp && \
        yum groupinstall 'Development Tools' -y && \
        yum install zlib-devel bzip2-devel openssl-devel ncurese-devel gcc python-pip -y 
        if [[ ! -f  Python-3.6.4.tar.xz ]];then
        wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz 
        fi
        if [[ ! -d Python-3.6.4 ]];then
            tar -xf Python-3.6.4.tar.xz
        fi
        cd Python-3.6.4 && \
        ./configure --prefix=/usr/local/python3 && \
        make && make install && \
        ln -s /usr/local/python3/bin/python3 /usr/bin/python3 && \
        ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3

    else
	    echo "Other OS: $sysOS"
    fi
fi

which python3

if [[ $? == 0 ]];then
setup_env
fi
