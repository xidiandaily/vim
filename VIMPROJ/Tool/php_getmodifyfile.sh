#!/bin/sh
#初始化
mydir=`dirname $0`;
source "$mydir/shell.init.sh"

DIR=`pwd -P`;
FILELIST=uploadfile.txt
TIMESTEMP=timestamp.txt

if [ -f "$FILELIST" ];then
    rm $FILELIST
fi

cd $DIR;
touch $FILELIST;
if [ -f "$TIMESTEMP" ];then
    cmd="";
    if [[ "Darwin" == $shell_type ]];then
        cmd="find -E . -type f -iregex \".*(php|js|html|tpl|css)$\" -newer $TIMESTEMP -size -10M";
    else
        cmd="find -type f -regextype awk  -regex \".*(php|js|html|tpl|css)$\" -newer $TIMESTEMP -size -10M";
    fi

    for i in `eval $cmd`; do
        n=`echo $i|sed -e "s/\.\///g"`;
        echo $n>>$FILELIST;
    done
fi

