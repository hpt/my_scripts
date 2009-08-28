# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# for using ctrl-s in readline as forward-search-history
stty -ixon

# try to have a look and edit history expansion before running ...
shopt -s histverify
shopt -s histreedit

# User specific aliases and functions
alias ll='ls -l'
alias l='ls -l'
alias la='ls -a'
alias m='more'
alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ..'
alias rm='rm -i'
alias lf='ls'
alias j='jobs'
alias ct='ctags -R --c-types=+cdefgmnpstuvs *'
alias f='free -mo'
alias mu='sudo mount /dev/sda1 /mnt/udisk'
alias uu='sudo umount /mnt/udisk'
alias grep='grep --color'
# from coreutils' FAQ
alias del='mv --verbose --backup=simple --suffix=$(date +".(%F_%T)") --target-directory=$HOME/.Trash/'

# for readline bindings query:
alias bindq='bind -q'
complete -A binding bindq

#temp english env
#alias en='env -u LANG'

#output in english
#alias c='env - cal'

alias rpml='rpm -ql'
alias rpmi='rpm -qi'

alias c++t='ctags --c++-types=+cdefvxdgmnpstu -R *'
alias c-='cd -'
alias cdo='eject'
alias cdc='eject -t'

alias qm='qmake -project;qmake;make'

# tmp alias
#alias cdw='cd ~/Work/GEFONDIALER_newCA/'
#alias cdgd='cd ~/Work/GEFONDIALER_newCA/GefonDialer_client/src/src/'
#alias cdgs='cd ~/Work/GEFONDIALER_newCA/GefonDialer_Server/src/'
#alias cdc='cd ~/Work/GEFONDIALER_newCA/client/'
#alias lsg='ls /var/ftp/pub/guodian/'
#alias cph='cp ~/Work/GEFONDIALER_newCA/install/include/GFVerify.h .'

# for correct man display of `'' and `"'
#alias man="LC_CTYPE=C man"

# for telnet to AIX with TERM set to vt100
alias telnet='TERM=vt100 telnet'


# when running int SCREEN, using the better complete. works with Fedora10
if [ -n "$STY" ];then
    complete -o filenames -F _root_command screen
fi

## FUNCTIONS
# query which package the command belonging to
rpmp()
{
	rpm -qf $(whereis $1|cut -d' ' -f2)
}

# vncviewer used at IBM pLinux ...
vv()
{
	vncviewer -Shared -MenuKey=F1 -passwd ~/.vnc/passwd $1 &
}

# remove the host which ssh key changed ...
rsk()
{
	flock /tmp/rsk_lock -c "\
	perl -ni -e 'if(!/$1/){print;}' ~/.ssh/known_hosts \
	"

}

# auto login or execute restricted remote commands (doesn't 
# include redirection commands such as ssh root@auroralp2 'cat > /tmp/kernel.rpm
# ' < kernel.rpm ) with ssh
assh()
{
	if [ $# -gt 1 ];then		# run remote command,'expect eof',background ok
		RUN_COMMAND=true
	else
		RUN_COMMAND=false	# autologin,'interact',background failure
	fi

	local TARGET=$1
	shift 1				# throw away host info

	if ! echo $TARGET | grep -q ".*@"	# if the $1 doesn't contain '@'...
	then
		TARGET=root@$TARGET		# make 'root@...' default
	fi
	local HOST=${TARGET##*@}
	
	expect -c "
set timeout 30
while 1 {
	spawn ssh $TARGET {$*}

	# must give a 'timeout' or 'default' when autologin, see man expect
	expect {
	        timeout {
	                puts {timeout to $*}
	                exit 0
	        }
	        \"(yes/no)?\" {
	                send \"yes\r\"
	                exp_continue
	        }
	        \"assword:\" {
	                send \"don2rry\r\"
			break
	        }
		\"ailed.\" {
			exec sh -c \". ~/.bashrc;rsk $HOST\"
			# cann't define HOST in this scope,otherwise
			# after rsk will be none string.
			close
			wait
			continue
		}
		\"onnection refuse\" {	# for the host refuse to connect
			puts \"Connection refused to $*\"
			exit 0
		}
		eof {			# for no password needed
			puts \"No password be needed....\"
			exit 0
		}
	}
}
if {$RUN_COMMAND} {
	set timeout -1
	expect eof
} else {
	interact {
		\"\\001es\" { send \"set -o emacs\r\"}
		\"\\001ios\" { send \"/LTE/tools/ltpr/gss.ltpr -f IO\r\"}
	}
}"
}

# functions
bu()
{
#tar czvf -  $1 > ./$1.$(date +%Y%m%d-%H%M%S).tgz;
    tar czvf $1.$(date +%Y%m%d-%H%M%S).tgz $1;
    if [ $? -eq 0 ]; then echo "Ok"; else echo "Failed";fi;
}

hd()
{
	hexdump -v -e '"%06.6_ad "  10/1 "%03X "'  -e '"\t" "%_p "' -e'"\n"' $1 | m;
}
		
dt()
{
	dict $1 | less;
}


#for apue search code.
gp()
{
	grep "$1" /home/hpt/source/apue_for_linux/Sourcefiles;
}	

# func to get the "canonical path"
# e.g. canpath /a/b/../c gets /a/c
# author: http://groups.google.com/group/comp.unix.shell/browse_thread/thread/3a110ca144baa58b/b25627c1a2e7a4b5?lnk=raot#b25627c1a2e7a4b5
canpath ()
{
    local OLDIFS="$IFS";
    local i=1 over=0 tmp="$1" root='';
    [[ $tmp == /* ]] && root=/;
    IFS="/";
    set -- ${tmp#/};
    unset IFS;
    while [[ $i -le $# ]]; do
        if [[ ${@:i:1} = .. ]]; then
            if [[ $i -eq 1 ]]; then
                ((over++));
                shift;
                continue;
            else
                ((i-=2));
                set -- "${@:1:i}" "${@:i+3}";
            fi;
        else
            if [[ ${@:i:1} = . ]]; then
                set -- "${@:1:i-1}" "${@:i+1}";
                continue;
            fi;
        fi;
        ((i++));
    done;
    tmp=;
    IFS=/;
    if [[ -n $root ]]; then
        tmp="/$*";
    else
        for ((i=0; i<over; i++))
        do
            tmp+="../";
        done;
        tmp+="$*";
    fi;
    IFS="$OLDIFS";
    echo "${tmp:-.}"
}

# open a assh.exp screen
assh_screen() 
{
    : ${1:?No machine specified}
    
    screen assh.exp -p "${PW_AS-rhts}" $1
}

# open a console screen
console_screen()
{
    : ${1:?No machine specified}

    screen console -M ${CONSOLE_SERVER:-console.lab.bos.redhat.com} -l phan $1
}

# loop through serveral dirs...
# needs building the stack first with 'pushd dir'
lcd() 
{ 
    if [ $# = 0 ]
    then
	local stack_height=$(dirs -p|wc -l)
    	[[ $stack_height -eq 1 ]] && echo "No alternative dir for looping..." && return 0
    	pushd +$((stack_height-1)) 
    elif [ $# = 1 ]
    then
	local target_dir_pos=$(dirs -v |grep -E "$1" |awk '{a[$2]=$1};END{for(i in a)print a[i]}')
	[ -z "$target_dir_pos" ] && echo "Cannot find the target: $1" && return 0

	local target_dir_num=$(echo "$target_dir_pos"|wc -l)

	if [  "$target_dir_num" -gt 1 ]
	then
	    echo -e "Ambigous target:\n" "$(dirs -v |grep -E "$1")" && return 0
	fi
	pushd +$target_dir_pos
    fi
}

# find out the newest file
# come from irc.freenode.net #bash
latest ()
{
    local file files=("${1:-.}/"*) latest=$files;
    for file in "${files[@]}";
    do
        [[ $file -nt $latest ]] && latest=$file;
    done;
    echo "$latest"
}

#export PROMPT_COMMAND='echo -ne "\0337\033[2;999r\033[1;1H\033[00;44m\033[K"`date "+%D %k:%M:%S"` CST"\033[00m\0338"'

# for 'screen's dynamic window's title
if [ ${TERM} = "screen" ];then export PROMPT_COMMAND='echo -ne "k\\"';fi
