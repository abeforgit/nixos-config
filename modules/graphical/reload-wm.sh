#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -m | while read -r monitor; do

	if  echo "$monitor" | grep "primary";  then
		MONITOR=''${monitor//:*/} polybar primary &
	else
		MONITOR=''${monitor//:*/} polybar secondary &
	fi
done
