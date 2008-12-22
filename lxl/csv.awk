#!/usr/bin/gawk --exec
BEGIN { 
	FS=OFS=SUBSEP 
	IGNORECASE=1
	pon=PO
} 

function rebuild_line(	n,f,i,inFld)
{
	n = split($0,f,"")
	$0 = ""
	for (i=1;i<=n;i++) {
		inFld = (f[i] == "\"" ? !inFld : inFld)
		$0 = $0 (!inFld && (f[i] == ",") ? FS : f[i])
	}
}

{
	rebuild_line()
	if (NF != 48)
		next

	if (!header_printed && $21 ~ /serial/) {
		header = $0

		while (getline) {
			rebuild_line()
			if (NF != 48)
				continue
			if ($21 ~ / |/) 	# no serial number ...
				no_serial = 1

			break
		}

		# print the header ...
		n = split(header,f,SUBSEP)
		if (!no_serial)
			print "PO#,"f[4]","f[8]","f[9]","f[13]","f[14]","f[22]","f[24]","f[25]
		else
			print "PO#,"f[4]","f[8]","f[9]","f[21]","f[25]
		header_printed = 1

	}
	if (!header_printed)
		next

	if (!no_serial) 
	    print pon","$4","$8","$9","$13","$14","$22","$24","$25
	else {
		gsub(/"/,"",$21)	# remove the ^" and "$
		n = split($21,f,",")	# base on the 21th -- serial number
		for (i=1;i<=n;i++) {
			print pon","$4","$8","$9","f[i]","$25
		}
	}
}

