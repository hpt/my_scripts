#!/bin/bash
WORKING_PATH="/tmp/.auto_st_scan.$$"
CONFIG_FILE="$HOME/etc/auto_st_scan.conf"
LOG_PATH="/tmp/auto_st_scan.log/"
LOG_FILE="$LOG_PATH/log"
TRUN_PATH="$HOME/bin/timed-run"

E_WPATH=64	#
E_CFILE=65	#
E_LPATH=66
E_SCMD=67	# simple command failed

eecho()
{
	echo $1 >>$LOG_FILE
	exit $2
}

[ ! -e "$LOG_PATH" ] && { mkdir -p $LOG_PATH || exit $E_LPATH; }
(echo;echo "====== `date` ======") >> $LOG_FILE
exec 2>>$LOG_FILE

trap 'echo Command failed: $BASH_COMMAND >>$LOG_FILE;exit $E_SCMD' ERR

[ ! -e "$CONFIG_FILE" ] && eecho "Config file cannot be found" $E_CFILE
[ ! -e "$WORKING_PATH" ] && { mkdir -p $WORKING_PATH || exit $E_WPATH; }
source $CONFIG_FILE

trap 'rm -rf $WORKING_PATH' KILL EXIT ERR

# do scan for one release ...
# scan release_array 
scan()
{
	local array
	eval array=(\"\${$1[@]}\")
	local RNAME="${array[0]}"
	local PAT="${array[1]}"
	local CMD="${array[2]}"
	local TOUT="${array[3]}"
	
	local WP="$WORKING_PATH/$RNAME"
	mkdir $WP

	for((i=4;i<${#array[@]};i++))
	do
		$TRUN_PATH "$TOUT" assh.exp -s ${array[i]} "$CMD" &>$WP/${array[i]} &
	done

	wait

	local failure_hosts=`grep -L -w "$PAT" $WP/*`
	if [ -n "$failure_hosts" ]
	then
		for h in $failure_hosts
		do
			echo "`basename $h`:"
			cat $h
			echo
		done | mail -s "ST problems for $RNAME" hpt@localhost
	else
		echo "Seems all ST testing are fine for $RNAME."|mail -s "ST runing fine." hpt@localhost
	fi
}

# main
for a in ${!CLIENTS*}
do
	scan $a &
done

wait

exit 0
