#! /usr/bin/env bash
declare -A windowmap

result=$(rofi -kb-accept-entry Alt+Shift+Control+Return -kb-accept-alt Return -show combi -run-command 'echo run:{cmd}' -window-command 'echo window:{window}')

if test -n "$result"; then
    prefix=$(echo "$result" | cut -d ':' -f 1)
    payload=$(echo "$result" | cut -d ':' -f 2-)

    if [ "$prefix" = "window" ]; then
        if bspc query -N -n .focused; then
            if [ "$1" = "bring" ]; then
                bspc node "$payload" -d focused
            else
                bspc node "$payload" -d "__"
                bspc node -s "$payload"
            fi
        else
            bspc node "$payload" -d focused
        fi
    else
        bspc node "$focused" -d __
        nohup "$payload" &
    fi
fi
