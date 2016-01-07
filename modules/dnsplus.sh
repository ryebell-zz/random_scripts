#!/bin/bash
# DNS zone checker with added domain tools.
domain=$1;
ip=$(dig +short $domain);
echo "DNS Records: (${domain})";
printf "@ (Root A Record):\n$(echo $ip | sed 's/^/ /')";
printf "($(whois $ip | grep OrgName | cut -d' ' -f2- |  sed -e 's/^[ \t]*//'))\n";
printf "MX:\n$(dig +short mx $domain | sed 's/^/ /')\n";
printf "NS:\n$(dig +short ns $domain | sed 's/^/ /')\n";
printf "rDNS:\n$(dig +short -x $ip | sed 's/^/ /')\n";
printf "Domain Information:\n"
case $domain in 
    *.com | *.net)
        whois $domain | grep  -ie "expiration date:" -ie "registrar:" -ie "domain status:" | tail -n6
        ;;
    *.co.uk)
        whois $domain | sed "s/^[ \t]*//" | grep  -ie "expiry date:" -ie "registration status" -ie "registrar:" -A1 | sed 'N;s/\n/ /' | awk '{gsub("-- ", "");print}' | sed '/Last updated:/d' 
        ;;
    *.org)
        whois $domain | grep  -ie "registry expiry date:" -ie "sponsoring registrar:" -ie "domain status:" 
        ;;
    *.edu)
        whois $domain | grep  -i "domain expires:" | sed 's/ \{2,\}/ /g' && echo "Registrar: EDUCAUSE"
        ;;
    *.ac)
        whois $domain | grep  -i "expiry" | tail
        ;;
    *.ad)
        whois $domain
        ;;
    *.ae)
        whois $domain | grep  -i "registrar:" | tail
        ;;
    *.af)
        whois $domain | grep  -ie "registry expiry date:" -ie "sponsoring registrar:" | sed 's/T.*//'
        ;;
    *.com.au)
        printf "Expiration Date: Unknown\n";
        whois $domain | grep -ie "Registrar Name" | awk '{print $1, $2, $3}'
        ;;
    *)
        echo "$domain is a non-compatible TLD for dnsplus v1.0"
        ;;
esac
