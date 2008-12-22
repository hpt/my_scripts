#!/bin/bash
export LC_ALL=zh_CN.utf-8

serial_number_file=`zenity --file-selection --title="请指定序列号CSV文件"`

[ -z "$serial_number_file" ] && zenity --error --text="必须指定一个序列号CSV文件！" && exit 99

sales_file=`zenity --file-selection --title="请指定销售信息文件"`

[ -z "$sales_file" ] && zenity --error --text="必须指定一个销售信息文件！" && exit 99

result_file=`zenity --file-selection --title="请指定保存结果的文件"`

[ -z "$result_file" ] && zenity --error --text="必须指定一个结果文件!" && exit 99

{ awk -f `dirname $0`/consolidation.awk $serial_number_file $sales_file > $result_file \
&& zenity --info --text="信息已经保存到$result_file."; } \
|| zenity --error --text="出错了...." 
