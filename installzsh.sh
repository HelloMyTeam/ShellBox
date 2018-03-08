#!/bin/bash

sysOS=`uname -s`

if [ $sysOS == "Darwin" ];then
    which brew
    if [[ $? != 0 ]];then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
elif [ $sysOS == "Linux" ];then
    yum update -y && \
    yum install zsh -y && \
    yum install git -y && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="af-magic"/g' ~/.zshrc && source ~/.zshrc"
	sed -i 's/robbyrussell/af-magic/g' ~/.zshrc && source ~/.zshrc   
else
	echo "Other OS: $sysOS"
fi