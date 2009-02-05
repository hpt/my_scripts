#!/bin/bash
MUSIC_PATH="$HOME/Music/"
IFS=$'\n'
musics=($(ls -1 $MUSIC_PATH/*.mp3));
n=${#musics[@]}
n=$(echo "$RANDOM % $n"|bc);
mpg321 "${musics[n]}";
