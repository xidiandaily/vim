#!/bin/sh

if [ $# -ne 4 ];then
	echo "argumemnt number err";
	read
	exit 0;
fi

export PATH=/usr/local/bin:/usr/bin:$PATH
WorkPath=`pwd`;
REMOTEIP=$1
REMOTEPORT=$2;
REMOTEDBASE=$3;
CHOICE=$4;

PROJBASEDIR=`echo $WorkPath| sed 's/\/$//' | awk -F '/' '{print $NF}'`;
REMOTEDIR=$REMOTEDBASE/$PROJBASEDIR;
DIR=$WorkPath;

shell_type=`uname`;

#验证合法性
echo "oh~, $shell_type"
if [ ! -d $DIR ];then
    echo "director "$DIR" not exist!!";
    read
    exit 0;
fi

if [ $CHOICE -eq 2 ];then
    ssh $REMOTEIP -p $REMOTEPORT remote_basedir=$REMOTEDBASE proj_dir=$PROJBASEDIR 'bash -s' <<'ENDSSH'
    cd $remote_basedir;pwd -P;echo $proj_dir;[ ! -d $proj_dir ] && mkdir $proj_dir; cd $proj_dir;pwd -P;
ENDSSH
fi

TIMESTEMP=timestamp.txt
FILELIST=uploadfile.txt

cd $DIR;
count=0;
if [ "$CHOICE" -eq 2 ];then
	rm $TIMESTEMP;
fi
if [ -f "$TIMESTEMP" ];then
	#for i in `find . -newer $TIMESTEMP -type f `; do 
	for i in `find -type f -regextype awk  -regex ".*(php|html|c|cpp|h|hpp|cxx|hxx|Makefile|so)$" -newer $TIMESTEMP -size -10M`; do
		n=`echo $i|sed -e "s/\.\///g"`;
		f=$DIR"/"$n;
		count=` expr $count + 1`;
		echo "scp -P $REMOTEPORT -rp $f $REMOTEIP:$REMOTEDIR/$n";
		scp -P $REMOTEPORT -rp $f "$REMOTEIP:$REMOTEDIR/$n";
	done
else
	f=$DIR"/*";
	count="all";
	echo "upload all file";
	scp -P $REMOTEPORT -rp $f "$REMOTEIP:$REMOTEDIR"
fi

#更改上传文件的权限
ssh $REMOTEIP -p $REMOTEPORT remote_cmd=$REMOTEDIR 'bash -s' <<'ENDSSH'
  # commands to run on remote host
  cd $remote_cmd; pwd
  find -type d -exec chmod 777 {} \;
  find -type f -exec chmod 666 {} \;
  find -type f -name "*.sh" -exec chmod 766 {} \;
  find -type f -name "*.sh" -exec dos2unix  {} \; 2>/dev/null
ENDSSH

touch $TIMESTEMP;

echo "upload file :"$count;
sleep 1;
#read;

