#!/bin/sh
# try to reverse out those:
# aaaaaaaaaaaaa
# bbbbbbbbbbbbb
# 
# ccccccccccccc
# ddddddddddddd
# To
# ccccccccccccc
# ddddddddddddd
#
# aaaaaaaaaaaaa
# bbbbbbbbbbbbb

DEL="====="
{ 
index=0
while read buf
do 
	if [ "$buf" != "$DEL" ]
	then 
		if [ -z "$element" ]
		then
			element="$buf""\n"
		else
			element="$element""$buf""\n"
		fi
	else 
		array[$index]="$element"
		((index++))
		element=
	fi
done

if [ ! -z "$element" ]
then
	array[$index]="$element"
fi

echo "${#array[@]}"

n=$((${#array[@]}-1))
for i in `seq 0 $n`
do 
	echo -en "${array[$((n-i))]}"
done 
}
