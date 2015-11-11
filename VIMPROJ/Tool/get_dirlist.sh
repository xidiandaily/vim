#!/bin/sh

file=$1;

if [[ "Darwin" -eq `uname` ]];then
    dirlist=`find . -type d  ! -path '*.svn*' ! -path '*.git*' `;
    dirlist2=`echo $dirlist |xargs | sed 's/\.\//,/g' | sed 's/\.//g' | sed 's/ //g' | sed 's/,//'`;
    echo ":set path+="$dirlist2>$file;
else
    dirlist=`$CYGWINPATH/find -type d  ! -path '*.svn*' ! -path '*.git*' `;
    dirlist2=`echo $dirlist | sed 's/\.\//,/g' | sed 's/\.//g' | sed 's/ //g' | sed 's/,//'`;
    echo ":set path+="$dirlist2>$file;
fi

