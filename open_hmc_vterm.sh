#!/bin/bash
E_LPAR=64	# the lpar doesn't be found ...
E_ARG=65	# argument's number is wrong ...
E_INFO=66	# cannot get the local hmc info copy ...
E_FSP=67	# cannot get the fsp info ...
E_HMC=68	# cannot get the hmc name from show_hmc.sh ...

WORKING_PATH="/tmp/vterm.$HOSTNAME.$$/"
mkdir -p $WORKING_PATH
export VTERM_RECORDER="$WORKING_PATH/recorder"
VTERM_PATH="/LTE/tools/vterm.exp"
SHOW_HMC_PATH="/LTE/tools/show_hmc.sh"
HMC_INFO_PATH="/data/.show_machine_on_hmc/cache"
HMC_INFO_LOCAL="$WORKING_PATH/hmc_info"

cleanup()
{
	rm -rf $WORKING_PATH
}

trap cleanup KILL EXIT

if [ "$#" -ne 1 ]
then
	cat <<-EOF
	Usage: `basename $0` lpar
	EOF
	exit $E_ARG
fi

HMC=`$SHOW_HMC_PATH -s -n $1|head -n1`
if [ "$?" -eq 0 ]
then
	cp $HMC_INFO_PATH $HMC_INFO_LOCAL 2>/dev/null \
	|| { sleep 1; cp $HMC_INFO_PATH $HMC_INFO_LOCAL 2>/dev/null; } \
	|| { echo "copy $HMC_INFO_PATH to $HMC_INFO_LOCAL failed."; exit $E_INFO; }

	FSP=`grep -w "$HMC:.*:$1" $HMC_INFO_LOCAL|cut -d':' -f 2`
	if [ -z "$FSP" ]
	then
		echo "Cannot get the FSP name!"
		exit $E_FSP
	fi

	cat > $VTERM_RECORDER <<-EOF
	set $1 {"ssh hscroot@$HMC" "" "abc123" "rmvterm -m $FSP -p $1" "mkvterm -m $FSP -p $1"}
	EOF

	$VTERM_PATH $1
else
	echo "Seems cannot find out related info about lpar $1."
	exit $E_HMC
fi

exit 0
