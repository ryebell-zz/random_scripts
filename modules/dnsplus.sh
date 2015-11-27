#!/bin/bash
# DNS zone checker with added domain tools.
DOMAIN=$1;
IP=$(dig +short $DOMAIN);
echo "DNS Records:";
echo "@ (Root A Record):\n$(echo $IP | sed 's/^/ /')";
echo "MX:\n$(dig +short mx $DOMAIN | sed 's/^/ /')";
echo "NS:\n$(dig +short ns $DOMAIN | sed 's/^/ /')";
echo "rDNS:\n$(dig +short -x $IP | sed 's/^/ /')";
echo "Domain Information:"
case $DOMAIN in 
    *.com | *.net)
        whois $DOMAIN | grep  -ie "expiration date:" -ie "registrar:" -ie "domain status:" | tail -n6
        ;;
    *.co.uk)
        whois $DOMAIN | sed "s/^[ \t]*//" | grep  -ie "expiry date:" -ie "registration status" -ie "registrar:" -A1 | sed 'N;s/\n/ /' | awk '{gsub("-- ", "");print}' | sed '/Last updated:/d' 
        ;;
    *.org)
        whois $DOMAIN | grep  -ie "registry expiry date:" -ie "sponsoring registrar:" -ie "domain status:" 
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
