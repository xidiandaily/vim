#!/bin/sh
WorkPath=`pwd`
DIR=$WorkPath/$1
ROMOTE=$2
COUNT=$3
FILELIST=$DIR/uploadfile.txt
FILEWTIME=$DIR/file_with_time.txt


rm -f $FILELIST
rm -f $FILEWTIME

cd $DIR
ls -thl * | head -n $COUNT > $FILEWTIME
cd -

if [ "$COUNT" -gt 100 ];then
	echo "scp -P 3600 -rp $DIR/* LawrenceChi@192.168.100.144:$ROMOTE"
	scp -P 3600 -rp $DIR LawrenceChi@192.168.100.144:$ROMOTE
else
	while read cmdline
	do
		echo `echo $cmdline | awk -F" " '{print $10}'` >>$FILELIST
	done < $FILEWTIME

	while read f
	do
		echo "scp -P 3600 $DIR/$f LawrenceChi@192.168.100.144:$ROMOTE"
		scp -P 3600 $DIR/$f LawrenceChi@192.168.100.144:$ROMOTE
	done <$FILELIST

	tac $FILEWTIME
	tac $FILEWTIME | wc -l
fi

