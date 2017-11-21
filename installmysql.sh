#!/bin/bash
yum update -y 
cd `dirname $0`
name="mysql57-community-release-el7-11.noarch.rpm"
# yum install python-devel mysql-community-devel -y #python lib

if [ ! -f ${name} ];then
curl -O "https://repo.mysql.com//${name}"
fi

MD5="c070b754ce2de9f714ab4db4736c7e05"

filemd5="`md5sum ${name}`"
if [[ ${filemdt} -eq ${MD5} ]];then
echo "mysql file is ok"
sudo rpm -ivh ${name} 
echo "y" | sudo yum -y update && \
echo "y" | sudo yum -y install mysql-server && \
sudo systemctl start mysqld && \
sudo grep 'temporary password' /var/log/mysqld.log
echo "if use python, you need execute: yum install python-devel mysql-community-devel -y"
rm ${name}
fi
