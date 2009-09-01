#!/usr/bin/gawk --exec
BEGIN { 
	FS=SUBSEP 
	OFS=","
	#IGNORECASE=1
} 
function rebuild_line(	n,f,i,inFld)
{
    n = split($0,f,"")
    $0 = ""
    for (i=1;i<=n;i++) {
	inFld = (f[i] == "\"" ? !inFld : inFld)
	if (f[i] == "\"") i++
	$0 = $0 (!inFld && (f[i] == ",") ? FS : f[i])
    }
}

FNR==1{next}

{
    gsub(/[[:blank:]]+/,"")
    gsub(/[[:cntrl:]]+/,"")
    rebuild_line()
}
NF == 36 {		    # works on sales data ...
    #COUNTRY/COMPANY 18|BRAND/IMBRCODE 14|   PM 17  |   CS CODE 28  | OFFICE 19	| GPVALE 23 |
    CNTRY=$18;		BRAND=$14;	    PM=$17;	CS=$28;	    OFIC=$19
    money=$25
    gpvalue=$23
    #LENOVO PC 
    if (CNTRY == "HK" && BRAND == "LENOV" && PM == "CA" && CS ~ /LD|PC/ && OFIC == "HK" ) {
        LENOVO_PC+=money
	LENOVO_PC_GPV+=gpvalue
        next
    }
    #LENOVO NB
    if (CNTRY == "HK" && BRAND == "LENOV" && PM == "CA" && CS == "NB" && OFIC == "HK" ) {
        LENOVO_NP+=money
	LENOVO_NP_GPV+=gpvalue
        next
    }
    #LENOVO OTHER
    if (CNTRY == "HK" && BRAND == "LENOV" && PM == "CA" && CS !~ /LD|NB|PC/ && OFIC == "HK" ) {
        LENOVO_OTHER+=money
	LENOVO_OTHER_GPV+=gpvalue
        next
    }
    #IBM SERVER(HK)
    if (CNTRY == "HK" && BRAND == "IBM" && PM == "RY" && CS != "NS" && OFIC == "HK" ) {
	IBM_SER_HK+=money
	IBM_SER_HK_GPV+=gpvalue
	next
    }
    #IBM STORAGE(HK)
    if (CNTRY == "HK" && BRAND == "IBM" && PM == "RY" && CS == "NS" && OFIC == "HK" ) {
        IBM_STRG_HK+=money
	IBM_STRG_HK_GPV+=gpvalue
        next
    }
    #IBM SOFTWARE   CS CODE: ALL
    if (CNTRY == "HK" && BRAND == "LOTUS" && PM == "RY" && OFIC == "HK" ) {
        IBM_SOFW+=money
	IBM_SOFW_GPV+=gpvalue
        next
    }
    #NETGEAR	CS CODE:ALL
    if (CNTRY == "HK" && BRAND == "NETGE" && PM == "MB" && OFIC == "HK" ) {
        NETGE+=money
	NETGE_GPV+=gpvalue
        next
    }
    #SAMSUNG COMMERCIAL CS CODE:ALL
    if (CNTRY == "HK" && BRAND == "SAMSU" && PM == "MB" && OFIC == "HK" ) {
        SAMSU_CMCL+=money
	SAMSU_CMCL_GPV+=gpvalue
        next
    }
    #HP WORKSTATION 
    if (CNTRY == "HK" && BRAND == "HPB" && PM == "MB" && CS ~ /PB/ && OFIC == "HK" ) {
        HP_WOKSTAN+=money
	HP_WOKSTAN_GPV+=gpvalue
        next
    }
    #HP RPOS
    if (CNTRY == "HK" && BRAND == "HPB" && PM == "MB" && CS ~ /HO/ && OFIC == "HK" ) {
        HP_RPOS+=money
	HP_RPOS_GPV+=gpvalue
        next
    }
    #HPB NB
    if (CNTRY == "HK" && BRAND == "HP" && PM == "FS" && CS ~ /NB/ && OFIC == "HK" ) {
        HPB_NB+=money
	HPB_NB_GPV+=gpvalue
        next
    }

    #HP HPB specially
    if (CNTRY == "CN" && BRAND == "HPB") {
	#HP BPC NON-RD
    	    if (PM == "EO" && CS !~ /NB/ && OFIC !~ /CD|CQ|GZ|GY|KM|SZ|NN|FZ|XM/ ) {
    	    HP_BPC_NON_RD+=money
    	    HP_BPC_NON_RD_GPV+=gpvalue
    	    }
    	#HP BNB Non-RD
    	if (PM == "HW" && CS ~ /NB/ && OFIC !~ /CD|CQ|GZ|GY|KM|SZ|NN|FZ|XM/ ) {
    	    HP_BNB_NON_RD+=money
    	    HP_BNB_NON_RD_GPV+=gpvalue
    	}
    	#HP NT SERVER   office:all
    	if (PM == "XL" && CS ~ /CC|DR|HD|NA|NC|SV|UP/) {
    	    HP_NT_SERVER+=money
    	    HP_NT_SERVER_GPV+=gpvalue
    	}
    	#HP GD RD	cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /GZ|SZ|NN|XM|FZ/) {
    	    HP_GD_RD+=money
    	    HP_GD_RD_GPV+=gpvalue
    	}
    	#HP SW RD	cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /CD|CQ|KM|GY/) {
    	    HP_SW_RD+=money
    	    HP_SW_RD_GPV+=gpvalue
    	}
    	#HP shandong RD cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /JN|TI|YT|QD/) {
    	    HP_SD_RD+=money
    	    HP_SD_RD_GPV+=gpvalue
    	}
    	#HP HeNan ShanXi RD cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /ZZ|TY|LY/) {
    	    HP_HN_SX_RD+=money
    	    HP_HN_SX_RD_GPV+=gpvalue
    	}
    	#HP ShangHai RD cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /SH/) {
    	    HP_SH_RD+=money
    	    HP_SH_RD_GPV+=gpvalue
    	}
    	#HP ZheJiang RD cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /HZ|NB/) {
    	    HP_ZJ_RD+=money
    	    HP_ZJ_RD_GPV+=gpvalue
    	}
    	#HP JiangSu RD cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /NJ|SU/) {
    	    HP_JS_RD+=money
    	    HP_JS_RD_GPV+=gpvalue
    	}
    	#HP AnHui RD cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /HF/) {
    	    HP_AH_RD+=money
    	    HP_AH_RD_GPV+=gpvalue
    	}
	next
    }
    #HPPM   office cs code:all
    if (CNTRY == "CN" && BRAND == "HPPM" && PM == "MW") {
        HPPM+=money
	HPPM_GPV+=gpvalue
        next
    }
    #APC(CHINA)	office cs code:all
    if (CNTRY == "CN" && BRAND == "APC" && PM == "MW") {
        APC+=money
	APC_GPV+=gpvalue
        next
    }
    #HP TD/TL	office:all
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "DJ" && CS ~ /SA|TD|TL/) {
        HP_TD_TL+=money
	HP_TD_TL_GPV+=gpvalue
        next
    }
    #HP DISK ARRAY office:all
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "DJ" && CS !~ /OL|SA|TD|TL/) {
        HP_DISK_ARRAY+=money
	HP_DISK_ARRAY_GPV+=gpvalue
        next
    }
    #HP MEDIA
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "DJ" && CS == "OL") {
        HP_MEDIA+=money
	HP_MEDIA_GPV+=gpvalue
        next
    }
    #QLOGIC(CHINA) office cs code:all
    if (CNTRY == "CN" && BRAND == "QLOGI" && PM == "DJ") {
        QLOGIC_CN+=money
	QLOGIC_CN_GPV+=gpvalue
        next
    }
    #DLINK
    if (CNTRY == "CN" && BRAND == "DLINK" && PM == "GL") {
        DLINK+=money
	DLINK_GPV+=gpvalue
        next
    }
    #Rui Jie Network
    if (CNTRY == "CN" && BRAND == "RUIJI" && PM == "GL") {
        RUIJI+=money
	RUIJI_GPV+=gpvalue
        next
    }
    #Huawei
    if (CNTRY == "CN" && BRAND == "HUAW" && PM == "RW" && CS != "NC") {
        HUAW_RW+=money
	HUAW_RW_GPV+=gpvalue
        next
    }
    #H3C
    if (CNTRY == "CN" && BRAND == "H3C" && PM == "RW") {
        H3C+=money
	H3C_GPV+=gpvalue
        next
    }
    #ZTE Network
    if (CNTRY == "CN" && BRAND == "ZTE" && PM == "GZ") {
        ZTE_NET+=money
	ZTE_NET_GPV+=gpvalue
        next
    }
    #Lenovo Server RD
    if (CNTRY == "CN" && BRAND == "LENOV" && PM == "GL") {
        LENOVO_SER_RD+=money
	LENOVO_SER_RD_GPV+=gpvalue
        next
    }
    #EIZO(HK)
    if (CNTRY == "HK" && BRAND == "EIZO" && PM == "ML" && CS !~ /GC|MM/ && OFIC == "HK") {
        EIZO_HK+=money
	EIZO_HK_GPV+=gpvalue
        next
    }
    #EIZO(CHINA)
    if (CNTRY == "CN" && BRAND == "EIZO" && PM == "ML" && CS !~ /GC|MM/) {
        EIZO_CN+=money
	EIZO_CN_GPV+=gpvalue
        next
    }
    #APC (HK)
    if (CNTRY == "HK" && BRAND == "APC" && PM == "AP" && OFIC == "HK") {
        APC_HK+=money
	APC_HK_GPV+=gpvalue
        next
    }
    #Qlogic(HK)
    if (CNTRY == "HK" && BRAND == "QLOGI" && PM == "AP" && OFIC == "HK") {
        QLOGIC_HK+=money
	QLOGIC_HK_GPV+=gpvalue
        next
    }
    #MATROX(HK)
    if (CNTRY == "HK" && BRAND == "MGA" && PM == "SL" && OFIC == "HK") {
        MATROX_HK+=money
	MATROX_HK_GPV+=gpvalue
        next
    }
    #MATROX(CHINA)
    if (CNTRY == "CN" && BRAND == "MGA" && PM == "SL") {
        MATROX_CN+=money
	MATROX_CN_GPV+=gpvalue
        next
    }
    #HP Unix Server 
    if (CNTRY == "CN" && BRAND == "HPVAL" && PM == "HX" && CS ~ /RS|SV/) {
        HP_UNIX_SER+=money
	HP_UNIX_SER_GPV+=gpvalue
        next
    }
    #HP Value Storage
    if (CNTRY == "CN" && BRAND == "HPVAL" && PM == "HX" && CS !~ /RS|SV/) {
        HP_VAL_STORG+=money
	HP_VAL_STORG_GPV+=gpvalue
        next
    }
    #NetApp
    if (CNTRY == "CN" && BRAND == "NETAP" && PM == "HX") {
        NETAPP+=money
	NETAPP_GPV+=gpvalue
        next
    }
    #Juniper
    if (CNTRY == "CN" && BRAND == "JUNIP" && PM == "DB") {
        JUNIPER+=money
	JUNIPER_GPV+=gpvalue
        next
    }
    #HS
    if (CNTRY == "CN" && BRAND == "HS" && PM == "HZ") {
        HS+=money
	HS_GPV+=gpvalue
        next
    }
    #HUAWEI
    if (CNTRY == "CN" && BRAND == "HUAW" && PM == "HZ" && CS == "NC") {
        HUAWEI_HZ+=money
	HUAWEI_HZ_GPV+=gpvalue
        next
    }
    #Cisco
    if (CNTRY == "CN" && BRAND == "CISCO" && PM ~ /ES|LX/) {
        CISCO+=money
	CISCO_GPV+=gpvalue
        next
    }
    #Extreme
    if (CNTRY == "CN" && BRAND == "EXTREME" && PM == "LX") {
        EXTREME+=money
	EXTREME_GPV+=gpvalue
        next
    }
    #Siemens
    if (CNTRY == "CN" && BRAND == "SIEME" && PM == "NT") {
        SIEMENS+=money
	SIEMENS_GPV+=gpvalue
        next
    }
    #IBM Server RD office:all
    if (CNTRY == "CN" && BRAND == "IBM" && PM == "HJ" && CS == "RS") {
        IBM_RD_SER+=money
	IBM_RD_SER_GPV+=gpvalue
        next
    }
    #IBM Server traditional office:all
    if (CNTRY == "CN" && BRAND == "IBM" && PM == "HJ" && CS != "RS") {
	IBM_TD_SER+=money
	IBM_TD_SER_GPV+=gpvalue
	next
    }
}

NF == 15 {				    # works on stock data ...
    #BRAND/IMBRCODE 8|   PM 11  |   CS CODE 10  | OFFICE 1	|
    BRAND=$8;	    PM=$11;	CS=$10;	    OFIC=$1
    money=$7
    #LENOVO PC 
    if ( BRAND == "LENOV" && PM == "CA" && CS ~ /LD|PC/ && OFIC == "HK" ) {
        LENOVO_PC_STOCK+=money
        next
    }
    #LENOVO NB
    if ( BRAND == "LENOV" && PM == "CA" && CS == "NB" && OFIC == "HK" ) {
        LENOVO_NP_STOCK+=money
        next
    }
    #LENOVO OTHER
    if ( BRAND == "LENOV" && PM == "CA" && CS !~ /LD|NB|PC/ && OFIC == "HK" ) {
        LENOVO_OTHER_STOCK+=money
        next
    }
    #IBM SERVER(HK)
    if ( BRAND == "IBM" && PM == "RY" && CS != "NS" && OFIC == "HK" ) {
	IBM_SER_HK_STOCK+=money
	next
    }
    #IBM STORAGE(HK)
    if ( BRAND == "IBM" && PM == "RY" && CS == "NS" && OFIC == "HK" ) {
        IBM_STRG_HK_STOCK+=money
        next
    }
    #IBM SOFTWARE   CS CODE: ALL
    if ( BRAND == "LOTUS" && PM == "RY" && OFIC == "HK" ) {
        IBM_SOFW_STOCK+=money
        next
    }
    #NETGEAR	CS CODE:ALL
    if ( BRAND == "NETGE" && PM == "MB" && OFIC == "HK" ) {
        NETGE_STOCK+=money
        next
    }
    #SAMSUNG COMMERCIAL CS CODE:ALL
    if ( BRAND == "SAMSU" && PM == "MB" && OFIC == "HK" ) {
        SAMSU_CMCL_STOCK+=money
        next
    }
    #HP WORKSTATION 
    if ( BRAND == "HPB" && PM == "MB" && CS ~ /PB/ && OFIC == "HK" ) {
        HP_WOKSTAN_STOCK+=money
        next
    }
    #HP RPOS
    if ( BRAND == "HPB" && PM == "MB" && CS ~ /HO/ && OFIC == "HK" ) {
        HP_RPOS_STOCK+=money
        next
    }
    #HPB NB
    if ( BRAND == "HP" && PM == "FS" && CS ~ /NB/ && OFIC == "HK" ) {
        HPB_NB_STOCK+=money
        next
    }

    #HP HPB specially
    #HP BPC NON-RD
    if ( BRAND == "HPB") {
	if (PM == "EO" && CS !~ /NB/ && OFIC !~ /CD|CQ|GZ|GY|KM|SZ|NN|FZ|XM/ ) {
	    HP_BPC_NON_RD_STOCK+=money
	}
	#HP BNB Non-RD
    	if (PM == "HW" && CS ~ /NB/ && OFIC !~ /CD|CQ|GZ|GY|KM|SZ|NN|FZ|XM/ ) {
    	    HP_BNB_NON_RD_STOCK+=money
    	}
    	#HP NT SERVER   office:all
    	if ( PM == "XL" && CS ~ /CC|DR|HD|NA|NC|SV|UP/) {
    	    HP_NT_SERVER_STOCK+=money
    	}
    	#HP GD RD	cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /GZ|SZ|NN|XM|FZ/) {
    	    HP_GD_RD_STOCK+=money
    	}
    	#HP SW RD	cs code:all
    	if (PM ~ /EO|HW/ && OFIC ~ /CD|CQ|KM|GY/) {
    	    HP_SW_RD_STOCK+=money
    	}
    	#HP shandong RD cs code:all
    	if (PM ~/EO|HW/ && OFIC ~ /JN|TI|YT|QD/) {
    	    HP_SD_RD_STOCK+=money
    	}
    	#HP HeNan ShanXi RD cs code:all
    	if (PM ~/EO|HW/ && OFIC ~ /ZZ|TY|LY/) {
    	    HP_HN_SX_RD_STOCK+=money
    	}
    	#HP ShangHai RD cs code:all
    	if (PM ~/EO|HW/ && OFIC ~ /SH/) {
    	    HP_SH_RD_STOCK+=money
    	}
    	#HP ZheJiang RD cs code:all
    	if (PM ~/EO|HW/ && OFIC ~ /HZ|NB/) {
    	    HP_ZJ_RD_STOCK+=money
    	}
    	#HP JiangSu RD cs code:all
    	if (PM ~/EO|HW/ && OFIC ~ /NJ|SU/) {
    	    HP_JS_RD_STOCK+=money
    	}
    	#HP AnHui RD cs code:all
    	if (PM ~/EO|HW/ && OFIC ~ /HF/) {
    	    HP_AH_RD_STOCK+=money
    	}
	next
    }
    #HPPM   office cs code:all
    if ( BRAND == "HPPM" && PM == "MW") {
        HPPM_STOCK+=money
        next
    }
    #APC(CHINA)	office cs code:all
    if ( BRAND == "APC" && PM == "MW") {
        APC_STOCK+=money
        next
    }
    #HP TD/TL	office:all
    if ( BRAND == "HPB" && PM == "DJ" && CS ~ /SA|TD|TL/) {
        HP_TD_TL_STOCK+=money
        next
    }
    #HP DISK ARRAY office:all
    if ( BRAND == "HPB" && PM == "DJ" && CS !~ /OL|SA|TD|TL/) {
        HP_DISK_ARRAY_STOCK+=money
        next
    }
    #HP MEDIA
    if ( BRAND == "HPB" && PM == "DJ" && CS == "OL") {
        HP_MEDIA_STOCK+=money
        next
    }
    #QLOGIC(CHINA) office cs code:all
    if ( BRAND == "QLOGI" && PM == "DJ") {
        QLOGIC_CN_STOCK+=money
        next
    }
    #DLINK
    if ( BRAND == "DLINK" && PM == "GL") {
        DLINK_STOCK+=money
        next
    }
    #Rui Jie Network
    if ( BRAND == "RUIJI" && PM == "GL") {
        RUIJI_STOCK+=money
        next
    }
    #Huawei
    if ( BRAND == "HUAW" && PM == "RW" && CS != "NC") {
        HUAW_RW_STOCK+=money
        next
    }
    #H3C
    if ( BRAND == "H3C" && PM == "RW") {
        H3C_STOCK+=money
        next
    }
    #ZTE Network
    if ( BRAND == "ZTE" && PM == "GZ") {
        ZTE_NET_STOCK+=money
        next
    }
    #Lenovo Server RD
    if ( BRAND == "LENOV" && PM == "GL") {
        LENOVO_SER_RD_STOCK+=money
        next
    }
    #EIZO(HK)
    if ( BRAND == "EIZO" && PM == "ML" && CS !~ /GC|MM/ && OFIC == "HK") {
        EIZO_HK_STOCK+=money
        next
    }
    #EIZO(CHINA)
    if ( BRAND == "EIZO" && PM == "ML" && CS !~ /GC|MM/) {
        EIZO_CN_STOCK+=money
        next
    }
    #APC (HK)
    if ( BRAND == "APC" && PM == "AP" && OFIC == "HK") {
        APC_HK_STOCK+=money
        next
    }
    #Qlogic(HK)
    if ( BRAND == "QLOGI" && PM == "AP" && OFIC == "HK") {
        QLOGIC_HK_STOCK+=money
        next
    }
    #MATROX(HK)
    if ( BRAND == "MGA" && PM == "SL" && OFIC == "HK") {
        MATROX_HK_STOCK+=money
        next
    }
    #MATROX(CHINA)
    if ( BRAND == "MGA" && PM == "SL") {
        MATROX_CN_STOCK+=money
        next
    }
    #HP Unix Server 
    if ( BRAND == "HPVAL" && PM == "HX" && CS ~ /RS|SV/) {
        HP_UNIX_SER_STOCK+=money
        next
    }
    #HP Value Storage
    if ( BRAND == "HPVAL" && PM == "HX" && CS !~ /RS|SV/) {
        HP_VAL_STORG_STOCK+=money
        next
    }
    #NetApp
    if ( BRAND == "NETAP" && PM == "HX") {
        NETAPP_STOCK+=money
        next
    }
    #Juniper
    if ( BRAND == "JUNIP" && PM == "DB") {
        JUNIPER_STOCK+=money
        next
    }
    #HS
    if ( BRAND == "HS" && PM == "HZ") {
        HS_STOCK+=money
        next
    }
    #HUAWEI
    if ( BRAND == "HUAW" && PM == "HZ" && CS == "NC") {
        HUAWEI_HZ_STOCK+=money
        next
    }
    #Cisco
    if ( BRAND == "CISCO" && PM ~ /ES|LX/) {
        CISCO_STOCK+=money
        next
    }
    #Extreme
    if ( BRAND == "EXTREME" && PM == "LX") {
        EXTREME_STOCK+=money
        next
    }
    #Siemens
    if ( BRAND == "SIEME" && PM == "NT") {
        SIEMENS_STOCK+=money
        next
    }
    #IBM Server RD office:all
    if (CNTRY == "CN" && BRAND == "IBM" && PM == "HJ" && CS == "RS") {
        IBM_RD_SER_STOCK+=money
        next
    }
    #IBM Server traditional office:all
    if (CNTRY == "CN" && BRAND == "IBM" && PM == "HJ" && CS != "RS") {
	IBM_TD_SER_STOCK+=money
	next
    }
}

END{
    printf "LENOVO_PC,%.0f,%.0f,%.2f\n"	 , LENOVO_PC	/10000,LENOVO_PC_STOCK/10000          ,   LENOVO_PC_GPV
    printf "LENOVO_NP,%.0f,%.0f,%.2f\n"	 , LENOVO_NP    /10000,  LENOVO_NP_STOCK/10000        ,   LENOVO_NP_GPV
    printf "LENOVO_OTHER,%.0f,%.0f,%.2f\n" , LENOVO_OTHER /10000,  LENOVO_OTHER_STOCK/10000     ,   LENOVO_OTHER_GPV
    printf "IBM_SER_HK,%.0f,%.0f,%.2f\n"   , IBM_SER_HK   /10000,  IBM_SER_HK_STOCK/10000       ,   IBM_SER_HK_GPV
    printf "IBM_STRG_HK,%.0f,%.0f,%.2f\n"  , IBM_STRG_HK  /10000,  IBM_STRG_HK_STOCK/10000      ,   IBM_STRG_HK_GPV
    printf "IBM_SOFW,%.0f,%.0f,%.2f\n"     , IBM_SOFW     /10000,  IBM_SOFW_STOCK/10000         ,   IBM_SOFW_GPV
    printf "NETGE,%.0f,%.0f,%.2f\n"        , NETGE        /10000,  NETGE_STOCK/10000            ,   NETGE_GPV
    printf "SAMSU_CMCL,%.0f,%.0f,%.2f\n"   , SAMSU_CMCL   /10000,  SAMSU_CMCL_STOCK/10000       ,   SAMSU_CMCL_GPV
    printf "HP_WOKSTAN,%.0f,%.0f,%.2f\n"   , HP_WOKSTAN   /10000,  HP_WOKSTAN_STOCK/10000       ,   HP_WOKSTAN_GPV
    printf "HP_RPOS,%.0f,%.0f,%.2f\n"      , HP_RPOS      /10000,  HP_RPOS_STOCK/10000          ,   HP_RPOS_GPV
    printf "HPB_NB,%.0f,%.0f,%.2f\n"       , HPB_NB       /10000,  HPB_NB_STOCK/10000           ,   HPB_NB_GPV
    printf "HP_BPC_NON_RD,%.0f,%.0f,%.2f\n", HP_BPC_NON_RD/10000,  HP_BPC_NON_RD_STOCK/10000    ,   HP_BPC_NON_RD_GPV
    printf "HP_BNB_NON_RD,%.0f,%.0f,%.2f\n", HP_BNB_NON_RD/10000,  HP_BNB_NON_RD_STOCK/10000    ,   HP_BNB_NON_RD_GPV
    printf "HP_NT_SERVER,%.0f,%.0f,%.2f\n" , HP_NT_SERVER /10000,  HP_NT_SERVER_STOCK/10000     ,   HP_NT_SERVER_GPV
    printf "HP_GD_RD,%.0f,%.0f,%.2f\n"     , HP_GD_RD     /10000,  HP_GD_RD_STOCK/10000         ,   HP_GD_RD_GPV
    printf "HP_SW_RD,%.0f,%.0f,%.2f\n"     , HP_SW_RD     /10000,  HP_SW_RD_STOCK/10000         ,   HP_SW_RD_GPV
    printf "HP_SD_RD,%.0f,%.0f,%.2f\n"     , HP_SD_RD     /10000,  HP_SD_RD_STOCK/10000         ,   HP_SD_RD_GPV
    printf "HP_HN_SX_RD,%.0f,%.0f,%.2f\n"  , HP_HN_SX_RD  /10000,  HP_HN_SX_RD_STOCK/10000      ,   HP_HN_SX_RD_GPV
    printf "HP_SH_RD,%.0f,%.0f,%.2f\n"     , HP_SH_RD     /10000,  HP_SH_RD_STOCK/10000         ,   HP_SH_RD_GPV
    printf "HP_ZJ_RD,%.0f,%.0f,%.2f\n"     , HP_ZJ_RD     /10000,  HP_ZJ_RD_STOCK/10000         ,   HP_ZJ_RD_GPV
    printf "HP_JS_RD,%.0f,%.0f,%.2f\n"     , HP_JS_RD     /10000,  HP_JS_RD_STOCK/10000         ,   HP_JS_RD_GPV
    printf "HP_AH_RD,%.0f,%.0f,%.2f\n"     , HP_AH_RD     /10000,  HP_AH_RD_STOCK/10000         ,   HP_AH_RD_GPV
    printf "HPPM,%.0f,%.0f,%.2f\n"         , HPPM         /10000,  HPPM_STOCK/10000             ,   HPPM_GPV
    printf "APC,%.0f,%.0f,%.2f\n"          , APC          /10000,  APC_STOCK/10000              ,   APC_GPV
    printf "HP_TD_TL,%.0f,%.0f,%.2f\n"     , HP_TD_TL     /10000,  HP_TD_TL_STOCK/10000         ,   HP_TD_TL_GPV
    printf "HP_DISK_ARRAY,%.0f,%.0f,%.2f\n", HP_DISK_ARRAY/10000,  HP_DISK_ARRAY_STOCK/10000    ,   HP_DISK_ARRAY_GPV
    printf "HP_MEDIA,%.0f,%.0f,%.2f\n"     , HP_MEDIA     /10000,  HP_MEDIA_STOCK/10000         ,   HP_MEDIA_GPV
    printf "QLOGIC_CN,%.0f,%.0f,%.2f\n"    , QLOGIC_CN    /10000,  QLOGIC_CN_STOCK/10000        ,   QLOGIC_CN_GPV
    printf "DLINK,%.0f,%.0f,%.2f\n"        , DLINK        /10000,  DLINK_STOCK/10000            ,   DLINK_GPV
    printf "RUIJI,%.0f,%.0f,%.2f\n"        , RUIJI        /10000,  RUIJI_STOCK/10000            ,   RUIJI_GPV
    printf "HUAW_RW,%.0f,%.0f,%.2f\n"      , HUAW_RW      /10000,  HUAW_RW_STOCK/10000          ,   HUAW_RW_GPV
    printf "H3C,%.0f,%.0f,%.2f\n"          , H3C          /10000,  H3C_STOCK/10000              ,   H3C_GPV
    printf "ZTE_NET,%.0f,%.0f,%.2f\n"      , ZTE_NET      /10000,  ZTE_NET_STOCK/10000          ,   ZTE_NET_GPV
    printf "LENOVO_SER_RD,%.0f,%.0f,%.2f\n", LENOVO_SER_RD/10000,  LENOVO_SER_RD_STOCK/10000    ,   LENOVO_SER_RD_GPV
    printf "EIZO_HK,%.0f,%.0f,%.2f\n"      , EIZO_HK      /10000,  EIZO_HK_STOCK/10000          ,   EIZO_HK_GPV
    printf "EIZO_CN,%.0f,%.0f,%.2f\n"      , EIZO_CN      /10000,  EIZO_CN_STOCK/10000          ,   EIZO_CN_GPV
    printf "APC_HK,%.0f,%.0f,%.2f\n"       , APC_HK       /10000,  APC_HK_STOCK/10000           ,   APC_HK_GPV
    printf "QLOGIC_HK,%.0f,%.0f,%.2f\n"    , QLOGIC_HK    /10000,  QLOGIC_HK_STOCK/10000        ,   QLOGIC_HK_GPV
    printf "MATROX_HK,%.0f,%.0f,%.2f\n"    , MATROX_HK    /10000,  MATROX_HK_STOCK/10000        ,   MATROX_HK_GPV
    printf "MATROX_CN,%.0f,%.0f,%.2f\n"    , MATROX_CN    /10000,  MATROX_CN_STOCK/10000        ,   MATROX_CN_GPV
    printf "HP_UNIX_SER,%.0f,%.0f,%.2f\n"  , HP_UNIX_SER  /10000,  HP_UNIX_SER_STOCK/10000      ,   HP_UNIX_SER_GPV
    printf "HP_VAL_STORG,%.0f,%.0f,%.2f\n" , HP_VAL_STORG /10000,  HP_VAL_STORG_STOCK/10000     ,   HP_VAL_STORG_GPV
    printf "NETAPP,%.0f,%.0f,%.2f\n"       , NETAPP       /10000,  NETAPP_STOCK/10000           ,   NETAPP_GPV
    printf "JUNIPER,%.0f,%.0f,%.2f\n"      , JUNIPER      /10000,  JUNIPER_STOCK/10000          ,   JUNIPER_GPV
    printf "HS,%.0f,%.0f,%.2f\n"           , HS           /10000,  HS_STOCK/10000               ,   HS_GPV
    printf "HUAWEI_HZ,%.0f,%.0f,%.2f\n"    , HUAWEI_HZ    /10000,  HUAWEI_HZ_STOCK/10000        ,   HUAWEI_HZ_GPV
    printf "CISCO,%.0f,%.0f,%.2f\n"        , CISCO        /10000,  CISCO_STOCK/10000            ,   CISCO_GPV
    printf "EXTREME,%.0f,%.0f,%.2f\n"      , EXTREME      /10000,  EXTREME_STOCK/10000          ,   EXTREME_GPV
    printf "SIEMENS,%.0f,%.0f,%.2f\n"      , SIEMENS      /10000,  SIEMENS_STOCK/10000          ,   SIEMENS_GPV
    printf "IBM_RD_SER,%.0f,%.0f,%.2f\n"   , IBM_RD_SER   /10000,  IBM_RD_SER_STOCK/10000       ,   IBM_RD_SER_GPV
    printf "IBM_TD_SER,%.0f,%.0f,%.2f\n"   , IBM_TD_SER   /10000,  IBM_TD_SER_STOCK/10000       ,   IBM_TD_SER_GPV
}
