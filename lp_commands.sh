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
    echo "USAGE:  lp_status.sh <action: active|reboot|shutdown|softreset|state> <hostname>"
    echo "        lp_status.sh help"
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

HMC=`grep -w ".*:.*:$2" $CACHE_FILE | cut -d':' -f1|head -n1`
SYS=`grep -w ".*:.*:$2" $CACHE_FILE | cut -d':' -f2|head -n1`
LPAR=`grep -w ".*:.*:$2" $CACHE_FILE|tr -d '\r' | cut -d':' -f3|head -n1`

if [ ! -z $1 ];then
    OPERATION=$1
    case ${OPERATION} in
        'active')
            cmd="chsysstate -r lpar -m $SYS -n $LPAR -o on -f $LPAR "
            ;;
        'reboot')
            cmd="chsysstate -r lpar -m $SYS -n $LPAR -o shutdown --immed --restart"
            ;;
        'shutdown')
            cmd="chsysstate -r lpar -m $SYS -n $LPAR -o shutdown --immed"
            ;;
        'softreset')
            cmd="chsysstate -r lpar -m $SYS -n $LPAR -o dumprestart "
            ;;
	'state')
	    cmd="lssyscfg -r lpar -m $SYS -Fname:state --filter \"\"lpar_names=$LPAR\"\""
	    ;;
    			
        'help')
            usage
            ;;
        *)
        usage
        ;;
    esac
fi

auto_run hscroot abc123 $HMC "$cmd"

###############################################################
# END
###############################################################
