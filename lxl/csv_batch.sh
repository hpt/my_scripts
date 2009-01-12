#!/bin/bash
BIN_PATH=$(dirname $0)

SRC_DIR=`zenity --file-selection --directory --save --title="请指定原始文件所在目录"`

[ -z "$SRC_DIR" ] && zenity --error --text="必须指定一个原始文件所在录目！" && exit 64

DET_DIR=`zenity --file-selection --directory --save --title="请指定一个存放结果的目录"`

[ -z "$DET_DIR" ] && zenity --error --text="必须指定存放结果的目录！" && exit 65

for f in $SRC_DIR/*
do
	PO=$(expr "$f" : '.*-\([^-]\+\)-.*')
	[ -z "$PO" ] && zenity --error --text="$f: 文件名中没有PO号！" && continue
	{ awk -v PO=$PO -f $BIN_PATH/csv.awk $f > $DET_DIR/$PO.csv \
		&& { succeeded_files=$succeeded_files" "$f;zenity --info --text="已经由$f生成$DET_DIR/$PO.csv。"; }; }\
		|| { failed_files=$failed_files" "$f;zenity --error --text="没有完成由$f生成$DET_DIR/$PO.csv的操作，请检查！"; }
done

[ ! -z "$succeeded_files" ] && zenity --info --text="下列文件转换成功：$succeeded_files"

[ ! -z "$failed_files" ] && zenity --info --text="下列文件转换失败：$failed_files"
