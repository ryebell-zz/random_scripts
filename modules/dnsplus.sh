#!/bin/bash
# DNS zone checker with added domain tools.
DOMAIN=$1;
IP=$(dig $DOMAIN | grep $DOMAIN | sed '/^;/ d' | awk '{print $5}');
echo "DNS Records:";
dig $DOMAIN | grep  $DOMAIN | sed '/^;/ d' | awk '{print $4,$5}';
dig mx $DOMAIN | grep  $DOMAIN | sed '/^;/ d' | awk '{print $4,$6}';
dig ns $DOMAIN | grep  $DOMAIN | sed '/^;/ d' | awk '{print $4,$5}';
dig -x $IP | grep  $DOMAIN | sed '/^;/ d' | awk '{print $4,$5}';
case $DOMAIN in 
    *.com | *.net)
        whois $DOMAIN | grep  -ie "expiration date:" -ie "registrar:" | tail -2
        ;;
    *.co.uk)
        whois $DOMAIN | sed "s/^[ \t]*//" | grep  -ie "expiry date:" -ie "registrar:" -A1 | sed 'N;s/\n/ /' | awk '{gsub("-- ", "");print}' | sed '/Last updated:/d'
        ;;
    *.org)
        whois $DOMAIN | grep  -ie "registry expiry date:" -ie "sponsoring registrar:" | tail -2
        ;;
    *.edu)
        whois $DOMAIN | grep  -i "domain expires:" | sed 's/ \{2,\}/ /g' && echo "Registrar: EDUCAUSE"
        ;;
    *.ac)
        whois $DOMAIN | grep  -i "expiry" | tail
        ;;
    *.ad)
        whois $DOMAIN
        ;;
    *.ae)
        whois $DOMAIN | grep  -i "registrar:" | tail
        ;;
    *.af)
        whois $DOMAIN | grep  -ie "registry expiry date:" -ie "sponsoring registrar:" | sed 's/T.*//'
        ;;
    *)
        echo "$DOMAIN is a non-compatible TLD for dnsplus v1.0"
        ;;
esac
