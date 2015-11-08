#/bin/bash

prj=$1;

if [ -z $prj ];then
    echo "project name is [NULL]". 
else
    cd $VIMPROJ
    echo "building ..."
    cp template.vim "$prj".vim
    echo "/Applications/MacVim.app/Contents/MacOS/Vim -g -S \$VIMPROJ/$prj.vim" > PROJ/"$prj".sh
    echo exit >> PROJ/"$prj".sh
    chmod +x PROJ/"$prj".sh
    #dos2unix $VIMPROJ/$prj.vim
    echo "done!"
    /Applications/MacVim.app/Contents/MacOS/Vim -g $prj.vim
fi

