# Start things
if   [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq  1 ]
then
    # xinit $XDG_CONFIG_HOME/X11/clientrc
elif   [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq  3 ]
then
    # sway
fi
