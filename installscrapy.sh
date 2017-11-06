#!/bin/bash
# 待判断操作系统
sudo yum -y install gcc gcc-c++ kernel-devel
sudo yum -y install python-devel libxslt-devel libffi-devel openssl-devel
pip install cryptography
sudo pip install --upgrade pip
sudo pip install scrapy
