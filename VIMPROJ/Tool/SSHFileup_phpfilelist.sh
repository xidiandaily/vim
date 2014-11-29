#!/bin/sh

if [ $# -ne 1 ];then
	echo "argumemnt number err";
	read
	exit 0;
fi

export PATH=/usr/local/bin:/usr/bin:$PATH
WorkPath=`pwd`;
DIR=$WorkPath/$1;

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
fi

FILELIST=uploadfile.txt
TIMESTEMP=timestamp.txt

if [ -f "$FILELIST" ];then
    rm $FILELIST
fi

cd $DIR;
count=0;
if [ -f "$TIMESTEMP" ];then
	for i in `find -type f -regextype awk  -regex ".*(php|js|html|tpl|css)$" -newer $TIMESTEMP -size -10M`; do
		n=`echo $i|sed -e "s/\.\///g"`;
        echo $n>>$FILELIST;
		#f=$DIR"/"$n;
        #echo $f>>$FILELIST;
		#count=` expr $count + 1`;
		#echo "scp -P $REMOTEPORT -rp $f $REMOTEIP:$REMOTEDIR/$n";
		#scp -P $REMOTEPORT -rp $f "$REMOTEIP:$REMOTEDIR/$n";
        #echo $f
	done
else
    echo "">$FILELIST
    echo "not found"
fi

#更改上传文件的权限
#ssh $REMOTEIP -p $REMOTEPORT remote_cmd=$REMOTEDIR 'bash -s' <<'ENDSSH'
#  # commands to run on remote host
#  cd $remote_cmd; pwd
#  find -type d -exec chmod 777 {} \;
#  find -type f -exec chmod 666 {} \;
#  find -type f -name "*.sh" -exec chmod 766 {} \;
#  find -type f -name "*.sh" -exec dos2unix  {} \; 2>/dev/null
#ENDSSH
#


#touch $TIMESTEMP;

#echo "upload file :"$count;
#sleep 1;
#read;
