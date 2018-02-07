#/bin/bash

sysOS=`uname -s`

if [ $sysOS == "Darwin" ];then
        which brew
        if [[ $? != 0 ]];then
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
    elif [ $sysOS == "Linux" ];then
        curl -L https://raw.githubusercontent.com/hello--world/Shell/master/installzsh.sh | sh
	sed -i 's/robbyrussell/af-magic/g' ~/.zshrc && source ~/.zshrc    else
	    echo "Other OS: $sysOS"
    fi
