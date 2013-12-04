#!/bin/sh

file=$1;

dirlist=`C:/cygwin64/bin/find -type d  ! -path '*.svn*' ! -path '*.git*' `;
dirlist2=`echo $dirlist | sed 's/\.\//,/g' | sed 's/\.//g' | sed 's/ //g' | sed 's/,//'`;
echo ":set path+="$dirlist2>$file;

