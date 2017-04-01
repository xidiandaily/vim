#/bin/bash
[[ -z $1 ]] && echo './set_log.sh [1|0] [1 open][0:close]' && exit;

choice=$1;
if [ $choice == '1' ];then
    defaults write org.vim.MacVim MMLogLevel 7;
    defaults write org.vim.MacVim MMLogToStdErr 1;
    echo '/Applications/MacVim.app/Contents/MacOS/Vim -g -f 2> macvim.log';
elif [ $choice == '0' ];then
    defaults delete org.vim.MacVim MMLogLevel;
    defaults delete org.vim.MacVim MMLogToStdErr;
    echo 'stop macvim log';
else
    echo 'error input:'$choice;
    echo 'please run ./set_log.sh [1|0]';
fi

