#!/usr/bin/env bash

if (xrandr | grep "^DP-0.8 connected" &>/dev/null); then
    dp=/home/aarnphm/.config/screenlayout/triple.sh
else
	dp=/home/aarnphm/.config/screenlayout/one.sh
fi
[ -x "$dp" ] && . "$dp"

unset dp
