#!/bin/bash
CACHE_FILE="/data/.show_machine_on_hmc/cache"


##################################################################
# the expect script to autocheck ...
# args: username passwd host cmd
##################################################################
auto_run () 
{
	expect -c "
	set timeout 30
	set pwd_asked 0
	while 1 {
		spawn ssh -l $1 $3 {$4}
	
		# must give a 'timeout' or 'default' when autologin, see man expect
		expect {
		        timeout {
		                puts {timeout to $3}
		                exit 1
		        }
		        \"(yes/no)?\" {
		                send \"yes\r\"
		                exp_continue
		        }
		        \"assword:\" {
		                send \"$2\r\"
				break
		        }
			\"ailed.\" {
				exec flock $AUTO_RUN_RENEWKEY_LOCK -c \"perl -ni -e \'if (!/$3/){print;}\' ~/.ssh/known_hosts \"
				# cann't define HOST in this scope,otherwise
				# after rsk will be none string.
				close
				wait
				continue
			}
			\"onnection refuse\" {	# for the host refuse to connect
				puts \"Connection refused to $3\"
				exit 1
			}
			eof {			# for no password needed
				puts \"Failed to connect $3....\"
				exit 1
			}
		}
	}
	set timeout -1
	expect {
		\"assword:\" {	# password is wrong
		puts \"\nSeems wrong password ...\"
		exit 1
		}
		eof {}
	} " || echo "$AUTO_RUN_FAIL"
}
##############################################################
#  USAGE
##############################################################

usage()
{
    echo "USAGE:  lp_commands.sh <action: active|reboot|shutdown|softreset|state|refcode|profile> <hostname>"
    echo "        lp_commands.sh help"
    exit 1
}


##############################################################
#  START
##############################################################

if [ $# -ne 2 ];then
    usage
    exit
fi


grep -w ".*:.*:$2" $CACHE_FILE

if [ $? -ne 0 ]
then
    echo "Not Found"
    exit
fi

cache_recorder=`grep -w ".*:.*:$2" $CACHE_FILE |head -n1|tr -d '\r'`
SERVER=`expr "$cache_recorder" : "\([^:]*\):"`
FSP=`expr "$cache_recorder" : "[^:]*:\([^:]*\):"`
LPAR=`expr "$cache_recorder" : "[^:]*:[^:]*:\([^,]*\)"`
ID=`expr "$cache_recorder" : "[^:]*:[^:]*:[^,]*,\([0-9]\+\)"`

[[ -n "$ID" ]] && { username=padmin;passwd=padmin; } || { username=hscroot;passwd=abc123; }

case $1 in
    'active')
        #cmd="chsysstate -r lpar -m $FSP -n $LPAR -o on -f $LPAR "
	cmd="lssyscfg -r lpar -m $FSP -Fname:curr_profile --filter \"lpar_names=$LPAR\""
	    PROFILE=`auto_run $username $passwd $SERVER "$cmd" | tail -n 1 | tr '\r' ' ' | cut -d':' -f2 | awk '{print $1}'`
	    if [[ -z "$PROFILE" ]]; then
                cmd="chsysstate -r lpar -m $FSP -n $LPAR -o on -f $LPAR"
	    else	
                cmd="chsysstate -r lpar -m $FSP -n $LPAR -o on -f $PROFILE"
	    fi
        ;;
    'reboot')
        cmd="chsysstate -r lpar -m $FSP -n $LPAR -o shutdown --immed --restart"
        ;;
    'refcode')
        cmd="lsrefcode -r lpar -m $FSP -F lpar_name,refcode --filter \"lpar_names=$LPAR\""
        ;;
    'shutdown')
        cmd="chsysstate -r lpar -m $FSP -n $LPAR -o shutdown --immed"
        ;;
    'softreset')
        cmd="chsysstate -r lpar -m $FSP -n $LPAR -o dumprestart "
        ;;
    'state')
        cmd="lssyscfg -r lpar -m $FSP -F name,state --filter \"lpar_names=$LPAR\""
        ;;
    'profile')
	cmd="lssyscfg -r lpar -m $FSP -Fname:curr_profile --filter \"lpar_names=$LPAR\""
	;;
    'help')
        usage
        ;;
    *)
    usage
    ;;
esac

auto_run $username $passwd $SERVER "$cmd"

###############################################################
# END
###############################################################
