#!/bin/sh
#find -type f -regextype awk -regex ".*(c|cpp)" -exec stat -c %Y%n {} \; | sort -n -r | head -n 1 | sed "s/[0-9]*\.//" |   awk '{n=split($0, a,"/");for (i=1;i<=n;i++){ if(a[i]!=""){ printf "\\nnormal /\\v<%s>^M\\nnormal o\\n",a[i]}}}' >~openfile.tmp
$CYGWINPATH/find -type f -regextype awk -regex '.*(php|html|c|cpp|h|hpp|cxx|hxx|Makefile)' -exec stat -c %Y%n {} \; | $CYGWINPATH/sort -n -r | head -n 1 | sed "s/[0-9]*\.//" |   awk '{n=split($0, a,"/");for (i=1;i<=n;i++){ if(a[i]!=""){ printf "\nnormal /\\v<%s>\r \nnormal o\n",a[i]}}}' >~openfile.tmp
