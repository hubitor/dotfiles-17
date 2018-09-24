#!/usr/bin/sh

. ${XDG_CONFIG_HOME}/i3blocks/colors.sh

_col="${col_yel}"
_new="$(find $HOME/.mail/Gmail/INBOX/new | wc -l)"

case $BLOCK_BUTTON in
    1)  # Toggle offlineimap on or off
        if (systemctl is-active --user --quiet offlineimap.service)
        then
            systemctl --user stop  offlineimap.service
        else
            systemctl --user start offlineimap.service
        fi
        ;;
esac

if [ "$_new" -le 0 ]
then
    _ico=""
    _new=""
else
    _ico=""
fi

echo '<span color='"$_col"'>'"$_ico"'</span> '"$_new" | sed 's|&|&amp;|g'