#!/bin/bash
# tool for checking signature algorithm for installed SSL certificate remotely
test -z "$1" && echo "Usage: chksha domain.com" && return;
domain=$1;
openssl s_client -connect ${domain}:443 < /dev/null 2> /dev/null | openssl x509 -text -in /dev/stdin | grep "sha";
