#!/bin/bash

#IP
touch parse_file && cut /var/log/nginx/access.log-20220625 -d ' ' -f 1 > file;for i in `sort file | uniq`;do echo "$i count `grep -c $i file` " >> parse_file;done|sort parse_file -rn -k 3 | sendmail enter@email
rm -f parse_file
#Addresses
touch parse_address && cut /var/log/nginx/access.log-20220625 -d ' ' -f 7 > address;for i in `sort address | uniq`;do echo "$i count `grep -c \$i address` " >> parse_address;done|sort parse_address -rn -k 3 | sendmail enter@email
rm -f parse_address
