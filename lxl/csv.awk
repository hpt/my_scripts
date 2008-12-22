#!/usr/bin/gawk --exec
BEGIN { FS=OFS=SUBSEP 
	pon=PO
} 

{
	n = split($0,f,"")
	$0=""
	for (i=1;i<=n;i++) {
		inFld = (f[i] == "\"" ? !inFld : inFld)
		$0 = $0 (!inFld && (f[i] == ",") ? FS : f[i])
	}

	#$1=$1
	gsub(/"/,"",$21)	# remove the ^" and "$
	n = split($21,f,",")	# base on the 21th -- serial number
	if (n == 1)
		pon="PO#"
	else
		pon=PO
	for (i=1;i<=n;i++) {
		print pon","$4","$8","$9","f[i]","$25
	}
}

