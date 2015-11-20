dnsplus () 
{ 
    local DOMAIN=$1;
    local IP=$(dig $DOMAIN | grep $DOMAIN | sed '/^;/ d' | awk '{print $5}');
    local REVIP=$(echo "$IP" | awk 'BEGIN{FS=".";ORS="."} {for (i = NF; i > 0; i--){print $i}}');
    echo " ";
    echo -e "\e[1;35mDNS Records: \e[0m";
    dig $DOMAIN | grep --color=auto $DOMAIN | sed '/^;/ d' | awk '{print $4,$5}';
    dig mx $DOMAIN | grep --color=auto $DOMAIN | sed '/^;/ d' | awk '{print $4,$6}';
    dig ns $DOMAIN | grep --color=auto $DOMAIN | sed '/^;/ d' | awk '{print $4,$5}';
    dig -x $IP | grep --color=auto $DOMAIN | sed '/^;/ d' | awk '{print $4,$5}';
    dig +short $(echo $REVIP)zen.spamhaus.org;
    dig +short $(echo $REVIP)rhsbl.sorbs.net;
    case $DOMAIN in 
        *.com | *.net)
            whois $DOMAIN | grep --color=auto -ie "expiration date:" -ie "registrar:" | tail -2
        ;;
        *.co.uk)
            whois $DOMAIN | sed "s/^[ \t]*//" | grep --color=auto -ie "expiry date:" -ie "registrar:" -A1 | sed 'N;s/\n/ /' | awk '{gsub("-- ", "");print}' | sed '/Last updated:/d'
        ;;
        *.org)
            whois $DOMAIN | grep --color=auto -ie "registry expiry date:" -ie "sponsoring registrar:" | tail -2
        ;;
        *.edu)
            whois $DOMAIN | grep --color=auto -i "domain expires:" | sed 's/ \{2,\}/ /g' && echo "Registrar: EDUCAUSE"
        ;;
        *.ac)
            whois $DOMAIN | grep --color=auto -i "expiry" | tail
        ;;
        *.ad)
            whois $DOMAIN
        ;;
        *.ae)
            whois $DOMAIN | grep --color=auto -i "registrar:" | tail
        ;;
        *.af)
            whois $DOMAIN | grep --color=auto -ie "registry expiry date:" -ie "sponsoring registrar:" | sed 's/T.*//'
        ;;
        *)
            echo "$DOMAIN is a non-compatible TLD for dnsplus v1.0"
        ;;
    esac
}

