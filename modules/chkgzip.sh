#!/bin/bash
# script for checking headers for gzip compression

test -z "$1" && echo "Usage: chkgzip domain.com" && return;
domain=$1;
curl -sI -H 'Accept-Encoding: gzip,deflate' ${domain} | grep -i "content-encoding";
