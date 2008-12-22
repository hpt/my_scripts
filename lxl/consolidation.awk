#!/usr/bin/gawk --exec
BEGIN { serial_table=ARGV[1]
	sales_table=ARGV[2]
	ARGV[2]=""
	ARGC=2

	FS="\t"
	header="Distributor Warehouse Number	Cisco Standard Part Number	Product Serial Number	SO Line Number (Order Line Item Number)	Distributor to Reseller Invoice Date (Shipped Date)	Distributor to Reseller Invoice Number	Original Distributor to Reseller Invoice Number	(Original) Re-Bill Invoice Number	Distributor to Reseller Sales Order Date	Distributor Sales Order Number	Original Distributor to Reseller Sales Order Number	(Original) Re-Bill Sales Order Number	Reseller to Distributor PO Number	Service Contract Number	SCC Quote Number	Drop Ship	Distributor PO Number to Cisco	Ship-To Name	Ship-To DUNS Number	Ship-To Address1	Ship-To Address2	Ship-To City	Ship-To State/Province/County/Region	Ship-To Zip / Postal Code	Ship-To Country	Bill-To Name	Bill-To DUNS Number	Bill-To Address1	BillTo Address2	Bill-To City	Bill-To State/Province/County/Region	Bill-To Zip / Postal Code	Bill-To Country	Buyer/Reseller Name	Buyer/Reseller Partner Identification	Cisco BE Identification	Buyer/Reseller DUNS Number	Buyer/Reseller Certification Level	Buyer/Reseller Address1	Buyer/Reseller Address2	Buyer/Reseller City	Buyer/Reseller State/Province/County/Region	Buyer/Reseller Zip / Postal Code	Buyer/Reseller Country	Buyer/Reseller Area	Reseller Contact Name	Reseller Contact Email	Reseller Contact Telephone	Product Quantity	Reported Product Unit Price - Local Currency	Reported Product Unit Price - USD	Reported Net POS Price	End Customer Name	End Customer DUNS Number	End Customer Address1	End Customer Address2	End Customer City	End Customer State/Province/County/Region	End Customer Zip / Postal Code	End Customer Country	End Customer Area	End Customer Contact Name	End Customer Contact Email	End Customer Contact Telephone	Reported Deal ID	Transaction Type	Promotion Authorization Number	Claim Eligibility Quantity	Claim Per Unit	Extended Claim Amount	Claim Reference Number"
	S = "\t"
	print header
}

$1 !~ /[1-9]/ {
	next
}

{ 
	gg_number=$11	#gg-number is 11th
	gsub(/ /, "", gg_number)
	gg_number=toupper(gg_number)
	while (getline sales_entry < sales_table) {
		n = split(sales_entry,f,"\t")	# gg-number is 4th
		gsub(/ /, "", f[4])
		f[4] = toupper(f[4])
		if (gg_number == f[4]) {	# bill-to-address1 is 37th; bill-to-name is 35th
			bill_to_name = f[35]
			bill_to_addr1 = f[37]
			zip = substr(bill_to_addr1, 1, 6)
			break
		}
	}
	close(sales_table)
	print $2 S $4 S $5 S S $6 S $11 S S S S S S S $11 S S S "N" S S S S S S S S S S bill_to_name S S bill_to_addr1 S S $2 S "PLS INPUT!!!" S zip S "CN" S "PLS INPUT!!!" S S S S "1" S S "PLS INPUT!!!" S "PLS INPUT!!!" S "COBO Unavailable" S S "COBO Unavailable" S $2 S "PLS INPUT!!!" S zip S "CN" S 
}
#NR == 1 {
#	getline sales_header < sales_table
#	close(sales_table)
#	print $0 "\t" sales_header
#}
#
#{
#	liao_number=$4	# liao-hao is 4th
#	#print gg_number
#	while(getline sales_entry < sales_table) {
#		n = split(sales_entry,f,"\t")	# gg-number is 4th; liao-hao is 6th
#		#print f[4]
#		gsub(/ /,"",gg_number)
#		gsub(/ /,"",f[4])
#		#if (gg_number == f[4]) {
#		if (gg_number == f[4] && liao_number == f[6]) {
#			print $0 "\t" sales_entry
#		}
#	}
#	close(sales_table)
#}
