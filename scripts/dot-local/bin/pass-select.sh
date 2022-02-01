#!/bin/bash

if [ -z "$1" ]
then
	pass ls|awk '/─/ {print $2}'
else
	pass show -c "$1" > /dev/null
fi
