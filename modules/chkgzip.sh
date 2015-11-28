#!/bin/bash
# script for checking headers for gzip compression

test -z "$1" && echo "Usage: chkgzip domain.com" && return;
domain=$1;
    if ! [[ $domain =~ ^https?:// ]]; then
        domain="http://${domain}";
    fi;

domain=$1;
curl -sI -H 'Accept-Encoding: gzip,deflate' ${domain} | grep -i "content-encoding";
