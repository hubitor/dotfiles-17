#!/usr/bin/sh

. ${XDG_CONFIG_HOME}/i3blocks/colors.sh
# Get color
_col="${1}"
case "$_col" in
    red)    _col="${col_red}" ;;
    orange) _col="${col_ora}" ;;
    yellow) _col="${col_yel}" ;;
    green)  _col="${col_gre}" ;;
    cyan)   _col="${col_cya}" ;;
    indigo) _col="${col_ind}" ;;
    violet) _col="${col_vio}" ;;
    brown)  _col="${col_bro}" ;;
    *)      _col="${col_vio}" ;;
esac

_file="/sys/class/backlight/${BRI_SCR}/brightness"

get_text () {
    _val="$(brightnessctl -d $BRI_SCR i | grep Current | sed 's|.*(\(.*\)%)|\1|')" || exit

    if   [ "$_val" -ge 75 ] ; then
        _icon=""
    elif [ "$_val" -ge 50 ] ; then
        _icon=""
    else
        _icon=""
    fi

    [ -z "${_val}" ] || echo '<span color='"$_col"'>'"$_icon"'</span> '"$_val"'%' | sed 's|&|&amp;|g'
}

text_loop () {
    while : ; do
        get_text
        sleep .2
        inotifywait --timeout -1 "${_file}" > /dev/null 2>&1 || break
    done
}

text_loop &

while read button ; do
    case $button in
        4) /usr/bin/brightnessctl -d $BRI_SCR s +5% > /dev/null 2>&1 ;;
        5) /usr/bin/brightnessctl -d $BRI_SCR s 5%- > /dev/null 2>&1 ;;
    esac
done
