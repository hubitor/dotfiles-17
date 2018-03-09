#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

case "$1" in
    --quit)
        echo ""
        ;;
    *)
        if [[ $(hostname) == 'sbpworkstation' ]]
        then
            nohup polybar wtop >/dev/null 2>&1 &
            nohup polybar wbot >/dev/null 2>&1 &
        else
            nohup polybar top >/dev/null 2>&1 &
            nohup polybar bot >/dev/null 2>&1 &
        fi
        ;;
esac