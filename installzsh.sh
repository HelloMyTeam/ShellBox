#!/bin/bash
yum update -y && \
yum install zsh -y && \
yum install git -y && \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="af-magic"/g' ~/.zshrc && source ~/.zshrc"
