#/bin/bash

prj=$1;

if [ -z $prj ];then
    echo "project name is [NULL]". 
else
    echo "building ..."
    cp template.vim "$prj".vim
    echo "/Applications/MacVim.app/Contents/MacOS/Vim -g $VIMPROJ/$prj.vim" > PROJ/"$prj".sh
    echo exit >> PROJ/"$prj".bat
    echo "done!"
    /Applications/MacVim.app/Contents/MacOS/Vim -g $prj.vim
fi

