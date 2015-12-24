#!/bin/sh
shell_type=`uname`;
echo "oh~, $shell_type"

if [[ $shell_type =~ "CYGWIN" ]];then
    export PATH=/usr/local/bin:/usr/bin:$PATH;
fi

FILELIST=uploadfile.txt
TIMESTEMP=timestamp.txt

