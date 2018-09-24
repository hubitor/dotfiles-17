#!/usr/bin/bash

. ${XDG_CONFIG_HOME}/i3blocks/colors.sh

_col="${col_cya}"
_int="${BLOCK_INSTANCE:-wifi}"
_ico=""
_ics="說"
_ic1=""
_ic2=""
_icp="爵"

[[ ! -d /sys/class/net/${_int}/wireless ]] && exit
[[ "$(cat /sys/class/net/${_int}/operstate)" = 'down' ]] && exit

_sid="$(iwgetid | sed 's|.*ESSID:"\(.*\)"|\1|')"
_sgn="$(grep ${_int} /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')"
_ipa="$(/usr/bin/ip -o -4 addr list ${_int} | awk '{print $4}' | cut -d/ -f1)"

# grabbing data for each adapter.
read rx < "/sys/class/net/${_int}/statistics/rx_bytes"
read tx < "/sys/class/net/${_int}/statistics/tx_bytes"
# get time
time=$(date +%s)
# write current data if file does not exist. Do not exit, this will cause
# problems if this file is sourced instead of executed as another process.
_sto="/tmp/i3-${_int}"
if ! [[ -f "${_sto}" ]]; then
  echo "${time} ${rx} ${tx}" > "${_sto}"
  chmod 0666 "${_sto}"
fi
# read previous state and update data storage
read old < "${_sto}"
echo "${time} ${rx} ${tx}" > "${_sto}"
# parse old data and calc time passed
old=(${old//;/ })
time_diff=$(( $time - ${old[0]} ))
# calc bytes transferred, and their rate in byte/s
rx_diff=$(( $rx - ${old[1]} ))
tx_diff=$(( $tx - ${old[2]} ))
rx_rate=$(( $rx_diff / $time_diff ))
tx_rate=$(( $tx_diff / $time_diff ))
# Download speed
rx_kib=$(( $rx_rate >> 10 ))
if hash bc 2>/dev/null && [[ "$rx_rate" -gt 1048576 ]]
then
    _dnl="$(echo "scale=1; $rx_kib / 1024" | bc) MiB/s"
else
    _dnl="${rx_kib} KiB/s"
fi
# Upload speed
tx_kib=$(( $tx_rate >> 10 ))
if hash bc 2>/dev/null && [[ "$tx_rate" -gt 1048576 ]]
then
    _upl="$(echo "scale=1; $tx_kib / 1024" | bc) MiB/s"
else
    _upl="${tx_kib} KiB/s"
fi

echo "<span color=${_col}>${_ico}</span> ${_sid} <span color=${_col}>${_ics}</span> ${_sgn}% <span color=${_col}>${_ic1}</span> ${_upl} <span color=${_col}>${_ic2}</span> ${_dnl} <span color=${_col}>${_icp}</span> ${_ipa}" | sed 's|&|&amp;|g'
