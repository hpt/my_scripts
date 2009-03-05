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
	$0 = $0 (!inFld && (f[i] == ",") ? FS : f[i])
    }
}

FNR==1{next}

{
    gsub(/[[:blank:]]+/,"")
    rebuild_line()
}
NF == 35 {		    # works on sales data ...
    #COUNTRY/COMPANY 18|BRAND/IMBRCODE 14|   PM 17  |   CS CODE 28  | OFFICE 19	|
    CNTRY=$18;		BRAND=$14;	    PM=$17;	CS=$28;	    OFIC=$19
    money=$25
    #LENOVO PC 
    if (CNTRY == "HK" && BRAND == "LENOV" && PM == "CA" && CS ~ /LD|PC/ && OFIC == "HK" ) {
        LENOVO_PC+=money
        next
    }
    #LENOVO NB
    if (CNTRY == "HK" && BRAND == "LENOV" && PM == "CA" && CS == "NB" && OFIC == "HK" ) {
        LENOVO_NP+=money
        next
    }
    #LENOVO OTHER
    if (CNTRY == "HK" && BRAND == "LENOV" && PM == "CA" && CS !~ /LD|NB|PC/ && OFIC == "HK" ) {
        LENOVO_OTHER+=money
        next
    }
    #IBM SERVER(HK)
    if (CNTRY == "HK" && BRAND == "IBM" && PM == "MX" && CS != "NS" && OFIC == "HK" ) {
	IBM_SER_HK+=money
	next
    }
    #IBM STORAGE(HK)
    if (CNTRY == "HK" && BRAND == "IBM" && PM == "MX" && CS == "NS" && OFIC == "HK" ) {
        IBM_STRG_HK+=money
        next
    }
    #IBM SOFTWARE   CS CODE: ALL
    if (CNTRY == "HK" && BRAND == "LOTUS" && PM == "MX" && OFIC == "HK" ) {
        IBM_SOFW+=money
        next
    }
    #NETGEAR	CS CODE:ALL
    if (CNTRY == "HK" && BRAND == "NETGE" && PM == "MB" && OFIC == "HK" ) {
        NETGE+=money
        next
    }
    #SAMSUNG COMMERCIAL CS CODE:ALL
    if (CNTRY == "HK" && BRAND == "SAMSU" && PM == "MB" && OFIC == "HK" ) {
        SAMSU_CMCL+=money
        next
    }
    #HP WORKSTATION 
    if (CNTRY == "HK" && BRAND == "HPB" && PM == "MB" && CS ~ /PB/ && OFIC == "HK" ) {
        HP_WOKSTAN+=money
        next
    }
    #HP RPOS
    if (CNTRY == "HK" && BRAND == "HPB" && PM == "MB" && CS ~ /HO/ && OFIC == "HK" ) {
        HP_RPOS+=money
        next
    }
    #HPB NB
    if (CNTRY == "HK" && BRAND == "HP" && PM == "FS" && CS ~ /NB/ && OFIC == "HK" ) {
        HPB_NB+=money
        next
    }
    #HP BPC NON-RD
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "EO" && CS !~ /CC|DR|HD|NA|NC|SV|UP/ && OFIC !~ /CD|CQ|GZ|GY|KM|SZ|NN|FZ|XM/ ) {
        HP_BPC_NON_RD+=money
        next
    }
    #HP BNB Non-RD
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "HW" && CS ~ /NB/ && OFIC !~ /CD|CQ|GZ|GY|KM|SZ|NN|FZ|XM/ ) {
        HP_BNB_NON_RD+=money
        next
    }
    #HP NT SERVER   office:all
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "XL" && CS ~ /CC|DR|HD|NA|NC|SV|UP/) {
        HP_NT_SERVER+=money
        next
    }
    #HP GD RD	cs code:all
    if (CNTRY == "CN" && BRAND == "HPB" && PM ~ /EO|HW/ && OFIC ~ /GZ|SZ|NN|XM|FZ/) {
	HP_GD_RD+=money
	next
    }
    #HP SW RD	cs code:all
    if (CNTRY == "CN" && BRAND == "HPB" && PM ~ /EO|HW/ && OFIC ~ /CD|CQ|KM|GY/) {
        HP_SW_RD+=money
        next
    }
    #HPPM   office cs code:all
    if (CNTRY == "CN" && BRAND == "HPPM" && PM == "MW") {
        HPPM+=money
        next
    }
    #APC(CHINA)	office cs code:all
    if (CNTRY == "CN" && BRAND == "APC" && PM == "MW") {
        APC+=money
        next
    }
    #HP TD/TL	office:all
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "DJ" && CS ~ /AI|SA|TD|TL/) {
        HP_TD_TL+=money
        next
    }
    #HP DISK ARRAY office:all
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "DJ" && CS !~ /AI|OL|SA|TD|TL/) {
        HP_DISK_ARRAY+=money
        next
    }
    #HP MEDIA
    if (CNTRY == "CN" && BRAND == "HPB" && PM == "DJ" && CS == "OL") {
        HP_MEDIA+=money
        next
    }
    #QLOGIC(CHINA) office cs code:all
    if (CNTRY == "CN" && BRAND == "QLOGI" && PM == "DJ") {
        QLOGIC_CN+=money
        next
    }
    #DLINK
    if (CNTRY == "CN" && BRAND == "DLINK" && PM == "GL") {
        DLINK+=money
        next
    }
    #Rui Jie Network
    if (CNTRY == "CN" && BRAND == "RUIJI" && PM == "GL") {
        RUIJI+=money
        next
    }
    #Huawei
    if (CNTRY == "CN" && BRAND == "HUAW" && PM == "RW" && CS != "NC") {
        HUAW_RW+=money
        next
    }
    #H3C
    if (CNTRY == "CN" && BRAND == "H3C" && PM == "RW") {
        H3C+=money
        next
    }
    #ZTE Network
    if (CNTRY == "CN" && BRAND == "ZTE" && PM == "GZ") {
        ZTE_NET+=money
        next
    }
    #Lenovo Server RD
    if (CNTRY == "CN" && BRAND == "LENOV" && PM == "GL") {
        LENOVO_SER_RD+=money
        next
    }
    #EIZO(HK)
    if (CNTRY == "HK" && BRAND == "EIZO" && PM == "ML" && CS !~ /GC|MM/ && OFIC == "HK") {
        EIZO_HK+=money
        next
    }
    #EIZO(CHINA)
    if (CNTRY == "CN" && BRAND == "EIZO" && PM == "ML" && CS !~ /GC|MM/) {
        EIZO_CN+=money
        next
    }
    #APC (HK)
    if (CNTRY == "HK" && BRAND == "APC" && PM == "ML" && OFIC == "HK") {
        APC_HK+=money
        next
    }
    #Qlogic(HK)
    if (CNTRY == "HK" && BRAND == "QLOGI" && PM == "ML" && OFIC == "HK") {
        QLOGIC_HK+=money
        next
    }
    #MATROX(HK)
    if (CNTRY == "HK" && BRAND == "MGA" && PM == "ML" && OFIC == "HK") {
        MATROX_HK+=money
        next
    }
    #MATROX(CHINA)
    if (CNTRY == "CN" && BRAND == "MGA" && PM == "ML") {
        MATROX_CN+=money
        next
    }
    #HP Unix Server 
    if (CNTRY == "CN" && BRAND == "HPVAL" && PM == "HX" && CS ~ /RS|SV/) {
        HP_UNIX_SER+=money
        next
    }
    #HP Value Storage
    if (CNTRY == "CN" && BRAND == "HPVAL" && PM == "HX" && CS !~ /RS|SV/) {
        HP_VAL_STORG+=money
        next
    }
    #NetApp
    if (CNTRY == "CN" && BRAND == "NETAP" && PM == "HX") {
        NETAPP+=money
        next
    }
    #Juniper
    if (CNTRY == "CN" && BRAND == "JUNIP" && PM == "DB") {
        JUNIPER+=money
        next
    }
    #HS
    if (CNTRY == "CN" && BRAND == "HS" && PM == "HZ") {
        HS+=money
        next
    }
    #HUAWEI
    if (CNTRY == "CN" && BRAND == "HUAW" && PM == "HZ" && CS == "NC") {
        HUAWEI_HZ+=money
        next
    }
    #Cisco
    if (CNTRY == "CN" && BRAND == "CISCO" && PM ~ /ES|LX/) {
        CISCO+=money
        next
    }
    #Extreme
    if (CNTRY == "CN" && BRAND == "EXTREME" && PM == "LX") {
        EXTREME+=money
        next
    }
    #Siemens
    if (CNTRY == "CN" && BRAND == "SIEME" && PM == "NT") {
        SIEMENS+=money
        next
    }
    #IBM Server 
    if (CNTRY == "CN" && BRAND == "IBM" && PM == "HJ") {
        IBM_SER+=money
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
    if ( BRAND == "IBM" && PM == "MX" && CS != "NS" && OFIC == "HK" ) {
	IBM_SER_HK_STOCK+=money
	next
    }
    #IBM STORAGE(HK)
    if ( BRAND == "IBM" && PM == "MX" && CS == "NS" && OFIC == "HK" ) {
        IBM_STRG_HK_STOCK+=money
        next
    }
    #IBM SOFTWARE   CS CODE: ALL
    if ( BRAND == "LOTUS" && PM == "MX" && OFIC == "HK" ) {
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
    #HP BPC NON-RD
    if ( BRAND == "HPB" && PM == "EO" && CS !~ /CC|DR|HD|NA|NC|SV|UP/ && OFIC !~ /CD|CQ|GZ|GY|KM|SZ|NN|FZ|XM/ ) {
        HP_BPC_NON_RD_STOCK+=money
        next
    }
    #HP BNB Non-RD
    if ( BRAND == "HPB" && PM == "HW" && CS ~ /NB/ && OFIC !~ /CD|CQ|GZ|GY|KM|SZ|NN|FZ|XM/ ) {
        HP_BNB_NON_RD_STOCK+=money
        next
    }
    #HP NT SERVER   office:all
    if ( BRAND == "HPB" && PM == "XL" && CS ~ /CC|DR|HD|NA|NC|SV|UP/) {
        HP_NT_SERVER_STOCK+=money
        next
    }
    #HP GD RD	cs code:all
    if ( BRAND == "HPB" && PM ~ /EO|HW/ && OFIC ~ /GZ|SZ|NN|XM|FZ/) {
	HP_GD_RD_STOCK+=money
	next
    }
    #HP SW RD	cs code:all
    if ( BRAND == "HPB" && PM ~ /EO|HW/ && OFIC ~ /CD|CQ|KM|GY/) {
        HP_SW_RD_STOCK+=money
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
    if ( BRAND == "HPB" && PM == "DJ" && CS ~ /AI|SA|TD|TL/) {
        HP_TD_TL_STOCK+=money
        next
    }
    #HP DISK ARRAY office:all
    if ( BRAND == "HPB" && PM == "DJ" && CS !~ /AI|OL|SA|TD|TL/) {
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
    if ( BRAND == "APC" && PM == "ML" && OFIC == "HK") {
        APC_HK_STOCK+=money
        next
    }
    #Qlogic(HK)
    if ( BRAND == "QLOGI" && PM == "ML" && OFIC == "HK") {
        QLOGIC_HK_STOCK+=money
        next
    }
    #MATROX(HK)
    if ( BRAND == "MGA" && PM == "ML" && OFIC == "HK") {
        MATROX_HK_STOCK+=money
        next
    }
    #MATROX(CHINA)
    if ( BRAND == "MGA" && PM == "ML") {
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
    #IBM Server 
    if ( BRAND == "IBM" && PM == "HJ") {
        IBM_SER_STOCK+=money
        next
    }
}

END{
    print "LENOVO_PC"	 , LENOVO_PC	,LENOVO_PC_STOCK
    print "LENOVO_NP"	 , LENOVO_NP    ,  LENOVO_NP_STOCK
    print "LENOVO_OTHER" , LENOVO_OTHER ,  LENOVO_OTHER_STOCK
    print "IBM_SER_HK"   , IBM_SER_HK   ,  IBM_SER_HK_STOCK
    print "IBM_STRG_HK"  , IBM_STRG_HK  ,  IBM_STRG_HK_STOCK
    print "IBM_SOFW"     , IBM_SOFW     ,  IBM_SOFW_STOCK
    print "NETGE"        , NETGE        ,  NETGE_STOCK
    print "SAMSU_CMCL"   , SAMSU_CMCL   ,  SAMSU_CMCL_STOCK
    print "HP_WOKSTAN"   , HP_WOKSTAN   ,  HP_WOKSTAN_STOCK
    print "HP_RPOS"      , HP_RPOS      ,  HP_RPOS_STOCK
    print "HPB_NB"       , HPB_NB       ,  HPB_NB_STOCK
    print "HP_BPC_NON_RD", HP_BPC_NON_RD,  HP_BPC_NON_RD_STOCK
    print "HP_BNB_NON_RD", HP_BNB_NON_RD,  HP_BNB_NON_RD_STOCK
    print "HP_NT_SERVER" , HP_NT_SERVER ,  HP_NT_SERVER_STOCK
    print "HP_GD_RD"     , HP_GD_RD     ,  HP_GD_RD_STOCK
    print "HP_SW_RD"     , HP_SW_RD     ,  HP_SW_RD_STOCK
    print "HPPM"         , HPPM         ,  HPPM_STOCK
    print "APC"          , APC          ,  APC_STOCK
    print "HP_TD_TL"     , HP_TD_TL     ,  HP_TD_TL_STOCK
    print "HP_DISK_ARRAY", HP_DISK_ARRAY,  HP_DISK_ARRAY_STOCK
    print "HP_MEDIA"     , HP_MEDIA     ,  HP_MEDIA_STOCK
    print "QLOGIC_CN"    , QLOGIC_CN    ,  QLOGIC_CN_STOCK
    print "DLINK"        , DLINK        ,  DLINK_STOCK
    print "RUIJI"        , RUIJI        ,  RUIJI_STOCK
    print "HUAW_RW"      , HUAW_RW      ,  HUAW_RW_STOCK
    print "H3C"          , H3C          ,  H3C_STOCK
    print "ZTE_NET"      , ZTE_NET      ,  ZTE_NET_STOCK
    print "LENOVO_SER_RD", LENOVO_SER_RD,  LENOVO_SER_RD_STOCK
    print "EIZO_HK"      , EIZO_HK      ,  EIZO_HK_STOCK
    print "EIZO_CN"      , EIZO_CN      ,  EIZO_CN_STOCK
    print "APC_HK"       , APC_HK       ,  APC_HK_STOCK
    print "QLOGIC_HK"    , QLOGIC_HK    ,  QLOGIC_HK_STOCK
    print "MATROX_HK"    , MATROX_HK    ,  MATROX_HK_STOCK
    print "MATROX_CN"    , MATROX_CN    ,  MATROX_CN_STOCK
    print "HP_UNIX_SER"  , HP_UNIX_SER  ,  HP_UNIX_SER_STOCK
    print "HP_VAL_STORG" , HP_VAL_STORG ,  HP_VAL_STORG_STOCK
    print "NETAPP"       , NETAPP       ,  NETAPP_STOCK
    print "JUNIPER"      , JUNIPER      ,  JUNIPER_STOCK
    print "HS"           , HS           ,  HS_STOCK
    print "HUAWEI_HZ"    , HUAWEI_HZ    ,  HUAWEI_HZ_STOCK
    print "CISCO"        , CISCO        ,  CISCO_STOCK
    print "EXTREME"      , EXTREME      ,  EXTREME_STOCK
    print "SIEMENS"      , SIEMENS      ,  SIEMENS_STOCK
    print "IBM_SER"      , IBM_SER      ,  IBM_SER_STOCK
}
