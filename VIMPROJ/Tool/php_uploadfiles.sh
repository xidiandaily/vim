#!/bin/sh
if [ $# -ne 3 ];then
	echo "argumemnt number err";
	read
	exit 0;
fi

SSHUSER=$1;
SSHPORT=$2;
SSHRemoteBaseDir=$3;
FILELIST="uploadfile.txt";

#初始化
mydir=`dirname $0`;
source "$mydir/shell.init.sh";

PROJBASEDIR=`pwd | sed 's/\/$//' | awk -F '/' '{print $NF}'`;
source "$mydir/SSHFileupload.sh";
touch $TIMESTEMP;

