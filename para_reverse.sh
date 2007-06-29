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
	assign=
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
		assign="OK"
	fi
done

if [ -z "$assign" ]
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
