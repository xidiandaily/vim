#!/bin/sh
#初始化
mydir=`dirname $0`;
source "$mydir/shell.init.sh"

if [[ 'Darwin' == `uname` ]];then
    find -E . -type f -regex '.*(php|html|c|cpp|h|hpp|cxx|hxx|Makefile)' -exec stat -f %c%N {} \; | sort -n -r | head -n 1 | sed "s/[0-9]*\.//" |   awk '{n=split($0, a,"/");for (i=1;i<=n;i++){ if(a[i]!=""){ printf "\nnormal /\\v<%s>\r \nnormal o\n",a[i]}}}' >.openfile.tmp
    #find . -type f -exec stat -f %c%N {} \; | sort -n -r | head -n 1 | sed "s/[0-9]*\.//" |   awk '{n=split($0, a,"/");for (i=1;i<=n;i++){ if(a[i]!=""){ printf "\nnormal /\\v<%s>\r \nnormal o\n",a[i]}}}' 
else
    $CYGWINPATH/find -type f -regextype awk -regex '.*(php|html|c|cpp|h|hpp|cxx|hxx|Makefile)' -exec stat -c %Y%n {} \; | $CYGWINPATH/sort -n -r | head -n 1 | sed "s/[0-9]*\.//" |   awk '{n=split($0, a,"/");for (i=1;i<=n;i++){ if(a[i]!=""){ printf "\nnormal /\\v<%s>\r \nnormal o\n",a[i]}}}' >~openfile.tmp
fi

