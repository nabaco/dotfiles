#!/bin/bash

if [ -z "$1" ]
then
	nodes=$(bspc query -N -n .hidden.local)

	for n in $nodes
	do
		wm_info=$(xprop -id $n)
		wm_class=$(xprop -id $n WM_CLASS|awk '{print $4}')
		wm_name=$(xprop -id $n WM_NAME|awk '{print $3 " " $4}')
		if [[ $wm_info != *"Error"* ]]
		then
			echo $n "$wm_class" "$wm_name"
		fi
	done
else
	node=$(echo $1|awk '{print $1}')
	bspc node $node -g hidden
fi
