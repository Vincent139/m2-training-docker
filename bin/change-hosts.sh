#!/bin/bash

# This file is used to change the hosts file of the container runner
declare -a urls=('formation.m2.local' 'admin.formation.m2.local')

for url in "${urls[@]}";	do
	echo $url
	if grep -q "$url" /etc/hosts ; then
		echo "$url aldready in /etc/hosts file";
	else
		echo "127.0.0.1	$url" >> /etc/hosts;
	fi
done
