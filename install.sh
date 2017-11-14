#!/bin/bash

# todo: install all or any one
#检查系统
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
		
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}

check_sys

update(){
	if [[ ${release} = "centos" ]]; then
		yum update
		aptyum=yum
# 		yum install -y vim git 

	else
		apt update
# 		apt-get install -y vim git
		aptyum=apt
	fi
}

update

install(){
	${aptyum} install $1	
}

Installation_git(){
	install git
}

Installation_pip(){
	install python-pip
}

if [ $1 -eq "pip" ];then
	Installation_pip
fi

# echo ${aptyum}
# check_sys 

# aptyum
