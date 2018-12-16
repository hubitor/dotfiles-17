#!/usr/bin/sh

wid=$1
class=$2
instance=$3
title="$(xwininfo -id $1 | awk 'NR==2' | sed 's|.*"\(.*\)"$|\1|')"

get_dropdown_flags() {
    drop_padding=120
    drop_height=420
    width="$(bspc wm --dump-state|jq -r '.monitors[].rectangle.width'|head -n1)"
    height="$(bspc wm --dump-state|jq -r '.monitors[].rectangle.height'|head -n1)"
    x_cor="$((drop_padding/2))"
    y_cor="$((height-drop_height))"
    drop_width="$((width-drop_padding))"
    drop_geom="${drop_width}x${drop_height}+${x_cor}+${y_cor}"
    echo "sticky=on hidden=on rectangle=${drop_geom}"
}

# Load workspace names
. $XDG_CONFIG_HOME/bspwm/window_id.sh

# Defaults
STATE=""
DESKTOP=""
FLAGS=""

case $class in
    # Monocle windows
    MATLAB*|*Remmina|*Octave|Spyder*|mpv|smplayer|vlc|Gimp*|inkscape|Blender|Zathura) STATE="monocle";;&
    # Force tiling
    Soffice|libreoffice*) STATE="tiled";;&
    # Desktop 1: is communication
    Skype|Rambox|Qemu*|*Remmina|Thunar)                 DESKTOP="${ws1}";;
    # Desktop 2: Internet
    qutebrowser|Firefox)                                DESKTOP="${ws2}";;
    # Desktop 3: Terminal
    Termite|kitty|Xfce4-terminal)                       DESKTOP="${ws3}";;
    # Desktop 4: Science
    MATLAB*|*Octave|Spyder*)                            DESKTOP="${ws4}";;
    # Desktop 5: Reading
    Zathura|Evince)                                     DESKTOP="${ws5}";;
    # Desktop 6: Writing
    libreoffice*|Soffice)                               DESKTOP="${ws6}";;
    # Desktop 7: Media
    mpv|smplayer|cantata|vlc)                           DESKTOP="${ws7}";;
    # Desktop 8: Image
    pdfsam|Gimp*|inkscape|Blender|openscad|Ristretto)   DESKTOP="${ws8}";;
    # Desktop 9: Games
    Steam|Stepmania)                                    DESKTOP="${ws9}";;
    # Desktop 0: Settings
    Pavucontrol|Syncthing*|Pamac*|System*|Blueman*)     DESKTOP="${ws0}";;
esac

# Dropdown override
if [ "$title" = 'dropdown' ] ; then
    DESKTOP=""
    FLAGS="$(get_dropdown_flags)"
    STATE="floating"
fi

OUTPUT="${FLAGS}"
[ ! -z "${DESKTOP}" ] && OUTPUT="${OUTPUT} desktop=${DESKTOP}"
[ ! -z "${STATE}" ] && STATE="${OUTPUT} state=${STATE}"

# Payload
echo "${OUTPUT}"
