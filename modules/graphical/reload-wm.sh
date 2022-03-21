#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -m | while read -r monitor; do

	if  echo "$monitor" | grep "primary";  then
		MONITOR=''${monitor//:*/} polybar primary >$XDG_DATA_HOME/polybar.log 2>&1 &
	else
		MONITOR=''${monitor//:*/} polybar secondary >$XDG_DATA_HOME/polybar.log 2>&1 &
	fi
done
herbstclient reload
