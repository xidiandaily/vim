#!/bin/sh

export PATH=/usr/local/bin:/usr/bin:$PATH
WorkPath=`pwd`;
DIR=$WorkPath/$1;
ROMOTE=$2;
CHOICE=$3;


TIMESTEMP=timestamp.txt
FILELIST=uploadfile.txt

cd $DIR;
count=0;
if [ $CHOICE -eq "2" ];then
	rm $TIMESTEMP;
fi
if [ -f "$TIMESTEMP" ];then
	#for i in `find -name "*[cpp|h|Makefile]" -newer $TIMESTEMP -type f `; do 
	for i in `find -regextype awk  -regex ".*(cpp|h|Makefile)$" -newer $TIMESTEMP `; do
		n=`echo $i|sed -e "s/\.\///g"`;
		f=$DIR"/"$n;
		count=` expr $count + 1`;
		echo "scp -P 3600 -rp $f LawrenceChi@192.168.100.144:$ROMOTE/$n";
		scp -P 3600 -rp $f LawrenceChi@192.168.100.144:"$ROMOTE/$n";
	done
else
	f=$DIR"/*";
	count="all";
	echo "upload all file";
	scp -P 3600 -rp $f LawrenceChi@192.168.100.144:$ROMOTE
fi
touch $TIMESTEMP;

echo "upload file :"$count;
#sleep 1;
#read;
