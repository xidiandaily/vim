#!/bin/sh

#test
#SSHUSER="lawrenceChi@192.168.200.144";
#SSHPORT=3600;
#SSHRemoteBaseDir="/usr/server/Mahjong.gb/Borrow/Compile";
#PROJBASEDIR="test_new_upload";
#FILELIST="uploadfile.txt";

if [ ! -f "$FILELIST" ];then
    echo "upload fail! $FILELIST not found. exit!";
    sleep 1;
    exit;
fi

#远程路径
REMOTEDIR=$SSHRemoteBaseDir/$PROJBASEDIR;

#保证远程有可用文件夹
echo "create $REMOTEDIR ing..."; 
ssh $SSHUSER -p $SSHPORT remote_basedir=$SSHRemoteBaseDir proj_dir=$PROJBASEDIR 'bash -s' <<'ENDSSH'
  cd $remote_basedir;pwd -P;echo $proj_dir;[ ! -d $proj_dir ] && mkdir $proj_dir; cd $proj_dir;pwd -P;
ENDSSH

echo "create $REMOTEDIR done!"; 

#上传变动的文件列表
echo "scp -P $SSHPORT -rp $FILELIST "$SSHUSER:$REMOTEDIR/$FILELIST""; 
scp -P $SSHPORT -rp $FILELIST "$SSHUSER:$REMOTEDIR/$FILELIST";

#上传
count=0;
for i in `cat $FILELIST`; do
    if [[ $i == "ALLFILE" ]]; then
        count="ALL File";
        echo "scp -P $SSHPORT -rp ./* $SSHUSER:$REMOTEDIR/";
        scp -P $SSHPORT -rp ./* "$SSHUSER:$REMOTEDIR";
        break;
    else
        count=`expr $count + 1`;
        echo "scp -P $SSHPORT -rp $i $SSHUSER:$REMOTEDIR/$i";
        scp -P $SSHPORT -rp $i "$SSHUSER:$REMOTEDIR/$i";
    fi
done

#更改上传文件的权限
echo "change permission..."; 
ssh $SSHUSER -p $SSHPORT filelist=$FILELIST remote_cmd=$REMOTEDIR 'bash -s' <<'ENDSSH'
  # commands to run on remote host
  cd $remote_cmd; pwd
  for i in `cat $filelist`;do
      if [[ $i == "ALLFILE" ]]; then
          find -type d -exec chmod 777 {} \;
          find -type f -exec chmod 666 {} \;
          find -type f -name "*.sh" -exec chmod 766 {} \;
          find -type f -name "*.sh" -exec dos2unix  {} \; 2>/dev/null
          break;
      else
          chmod 666 $i 2>/dev/null;
          dos2unix $i 2>/dev/null;
      fi
  done
ENDSSH

echo "change permission done!"; 
echo "upload file :"$count", all done!";
sleep 1;

