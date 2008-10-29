#!/bin/bash
n=$(ls -1 /home/hpt/Music/*.mp3|wc -l);
n=$(echo "$RANDOM % $n + 1"|bc);
i=0;
IFS=$'\n'
for f in $(ls -1 /home/hpt/Music/*.mp3);
do 
    ((i++)); 
    [[ $i -lt $n ]] && continue;
    echo $f;
    mpg321 "$f";
    break;
done
