#!/bin/sh
if [ $# -ne 4 ];then
	echo "argumemnt number err";
	read
	exit 0;
fi

#初始化
mydir=`dirname $0`;
source "$mydir/shell.init.sh"

SSHUSER=$1;
SSHPORT=$2;
SSHRemoteBaseDir=$3;
CHOICE=$4;
PROJBASEDIR=`pwd | sed 's/\/$//' | awk -F '/' '{print $NF}'`;

TIMESTEMP=timestamp.txt
FILELIST=uploadfile.txt

if [ "$CHOICE" -eq 2 ];then
	rm $TIMESTEMP;
fi

if [ -f $FILELIST ];then
	rm $FILELIST;
fi

if [ -f "$TIMESTEMP" ];then
	#for i in `find . -newer $TIMESTEMP -type f `; do 
    cmd="";
    if [[ "Darwin" == $shell_type ]];then
        cmd="find -E . -type f -iregex \".*(php|html|c|cpp|h|hpp|cxx|hxx|Makefile|so)$\" -newer $TIMESTEMP -size -10M";
    else
        cmd="find . -type f -regextype awk  -regex \".*(php|html|c|cpp|h|hpp|cxx|hxx|Makefile|so)$\" -newer $TIMESTEMP -size -10M";
    fi
	for i in `eval $cmd`; do
		n=`echo $i|sed -e "s/\.\///g"`;
        echo $n>>$FILELIST;
	done
else
    echo "ALLFILE">$FILELIST;
fi

source "$mydir/SSHFileupload.sh";
touch $TIMESTEMP;

