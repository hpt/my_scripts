#!/bin/bash
#: ${1:?"Usage: $0 [csv file]"}

CSV_FILE=`zenity --file-selection --title="请选择CSV文件"`

[ -z "$CSV_FILE" ] && zenity --error --text="必須选择一个CSV文件" && exit 99

PO=`zenity --entry --title="请输入PO号"`

RESULT_FILE=`zenity --file-selection --title="请指定结果文件名"`

[ -z "$RESULT_FILE" ] && zenity --error --text="必須选择一个结果文件" && exit 99

{ awk -v PO="$PO" -f `dirname $0`/csv.awk $CSV_FILE > $RESULT_FILE \
&& zenity --info --text="I have generated the selected file at $RESULT_FILE."; } \
|| zenity --error --text="Sorry, something failed..."
