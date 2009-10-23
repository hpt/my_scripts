#!/bin/bash

login()
{
    local init_header='
GET / HTTP/1.1
Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*
Accept-Language: en-us
Accept-Encoding: gzip, deflate
If-Modified-Since: Fri, 04 Aug 2006 11:34:13 GMT
If-None-Match: "AAAAQzY9kMI"
User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)
Host: global.synnex.com.cn
Connection: Keep-Alive
'
    local login_header='
POST /authen_filter/j_security_check HTTP/1.1
Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*
Referer: http://global.synnex.com.cn/authen_filter/Login.jsp?webapp=
Accept-Language: en-us
Content-Type: application/x-www-form-urlencoded
Accept-Encoding: gzip, deflate
User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)
Host: global.synnex.com.cn
Content-Length: 93
Connection: Keep-Alive
Cache-Control: no-cache
Cookie: JSESSIONID=COOKIE_STRING

j_company=HK&j_username=USER_NAME%7CHK&j_password=PASS_WORD&j_uri=http%3A%2F%2Fglobal.synnex.com.cn
'

    # hit the server ...
    cookie=`echo "$init_header" | nc global.synnex.com.cn 80 | sed -n 's/.*JSESSIONID=\([^;]\+\).*/\1/p'`

    if [[ -z "$cookie" ]]
    then
	echo "Cannot visit server for getting the cookie!"
	exit 65
    fi

    # login ...
    echo "$login_header" | sed 's/COOKIE_STRING/'"$cookie"'/;s/USER_NAME/'"$1"'/;s/PASS_WORD/'"$2"'/' | nc global.synnex.com.cn 80 
}

add()
{
    local header='
POST /pom/pomPRAE_add1.jsp HTTP/1.1
Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*
Referer: http://global.synnex.com.cn/pom/pomPRAE_add1.jsp
Accept-Language: en-us
Content-Type: application/x-www-form-urlencoded
Accept-Encoding: gzip, deflate
User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)
Host: global.synnex.com.cn
Content-Length: 123
Connection: Keep-Alive
Cache-Control: no-cache
Cookie: JSESSIONID=COOKIE_STRING

PM=AW&VendorAbbName=JUNIPERNETWORKS01631&CurrencyCode=USD&NoVatMark=Y&checkData=Y&NullOfNonVatMark=N&paycompanycodeTemp=HKD
'
    echo "$header" | sed 's/COOKIE_STRING/'"$cookie"'/' | nc global.synnex.com.cn 80 
}

. ./user_info

login $user $passwd
add
