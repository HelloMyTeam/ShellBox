#!/bin/bash
yum update -y &&
echo 'y' | yum install zsh -y && 
echo 'y' | yum install git -y && 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
