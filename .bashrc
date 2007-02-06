# .bashrc

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

# vncviewer used at IBM pLinux ...
vv()
{
	vncviewer -MenuKey=F1 -passwd ~/.vnc/passwd $1 &
}

# remove the host which ssh key changed ...
rsk()
{
	perl -ni -e "if(!/$1/){print;}" ~/.ssh/known_hosts
}

# auto login or execute restricted remote commands (doesn't 
# include redirection commands such as ssh root@auroralp2 'cat > /tmp/kernel.rpm
# ' < kernel.rpm ) with ssh
assh()
{
	if ! echo $1 | grep -q ".*@"
	then
		TEMP=$1
		shift 1
		set root@$TEMP $*
	fi
	local HOST=${1##*@}

	expect -c "
while 1 {
	spawn ssh $*
	expect {
		# must give a 'timeout' or 'default' when autologin, see man expect
	        timeout {
	                send_user \"\rtimeout for ssh to $*\r\"
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
			continue
		}
	}
}
interact"
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

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#export PROMPT_COMMAND='echo -ne "\0337\033[2;999r\033[1;1H\033[00;44m\033[K"`date "+%D %k:%M:%S"` CST"\033[00m\0338"'

# for 'screen's dynamic window's title
if [ ${TERM} = "screen" ];then export PROMPT_COMMAND='echo -ne "k\\"';fi
