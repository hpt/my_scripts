#!/bin/sh
# use lftp to list the ISOs on ftp3.linux.ibm.com. Using .netrc, no password needed.

LIST_FILE=/home/hpt/check_isos/iso_list
TMP_FILE=/home/hpt/check_isos/tmp_list
MAIL_ADDRESS=('hanpt@cn.ibm.com')

lftp_list ()
{
	lftp -c 'open ftp3.linux.ibm.com; \
		 ls -R redhat/beta_cds; \
		 ls -R suse/beta_cds'
}

if [ ! -f /home/hpt/check_isos/iso_list ]
then
	lftp_list > $LIST_FILE
	sleep 5
	exec $0
fi

lftp_list > $TMP_FILE

differ=$(diff -u $LIST_FILE $TMP_FILE)
if [ -n "$differ" ]
then
	echo "$differ" | mail -s "ISOs changed($(date '+%y/%m/%d'))" ${MAIL_ADDRESS[*]}
else
	echo "No new ISOs available" | mail -s "ISOs don't change.($(date '+%y/%m/%d'))" ${MAIL_ADDRESS[*]}
fi
