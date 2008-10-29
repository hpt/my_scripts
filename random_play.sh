#!/bin/bash
n=$(ls -1 /home/hpt/Music/*.mp3|wc -l);
IFS=$'\n'
musics=($(ls -1 /home/hpt/Music/*.mp3));
n=$(echo "$RANDOM % $n + 1"|bc);
mpg321 "${musics[n-1]}";
