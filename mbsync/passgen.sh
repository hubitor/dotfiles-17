#!/usr/bin/sh

_file="${XDG_CONFIG_HOME}/mbsync/password"
echo "echo $(pass Google | grep 'app:' | awk '{print $2}')" > "${_file}"
chmod 700 "${_file}"
