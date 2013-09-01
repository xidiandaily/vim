#!/bin/sh

if [ $# -ne 4 ];then
	echo "argumemnt number err";
	read
	exit 0;
fi

export PATH=/usr/local/bin:/usr/bin:$PATH
WorkPath=`pwd`;
DIR=$WorkPath/$1;
ROMOTE=$2;
PORT=$3;
CHOICE=$4;

shell_type=`uname`;

if  [[ $shell_type =~ "CYGWIN" ]];then
	echo "oh~, Cygwin"

	if [ ! -d $DIR ];then
		echo "director "$DIR" not exist!!";
		read
		exit 0;
	fi


else 
	if [ ! -d $DIR ];then
		echo "director "$DIR" not exist!!";
		read
		exit 0;
	fi

	if ! [[ $ROMOTE =~ '^.*[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\:.*$' ]];then
		echo "remote ip( $ROMOTE ) is not support!!";
		read
		exit 0;
	fi

	if ! [[ $PORT =~ '^[0-9]+$' ]];then
		echo "PORT: $PORT is not a support port!!";
		read
		exit 0;
	fi

fi

TIMESTEMP=timestamp.txt
FILELIST=uploadfile.txt

cd $DIR;
count=0;
if [ "$CHOICE" -eq 2 ];then
	rm $TIMESTEMP;
fi
if [ -f "$TIMESTEMP" ];then
	for i in `find . -newer $TIMESTEMP -type f `; do 
		n=`echo $i|sed -e "s/\.\///g"`;
		f=$DIR"/"$n;
		count=` expr $count + 1`;
		echo "scp -P $PORT -rp $f $ROMOTE/$n";
		scp -P $PORT -rp $f "$ROMOTE/$n";
	done
else
	f=$DIR"/*";
	count="all";
	echo "upload all file";
	scp -P $PORT -rp $f "$ROMOTE"
fi
touch $TIMESTEMP;

echo "upload file :"$count;
sleep 1;
#read;
