#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_speed()
{
    # Consts
    local THOUSAND=1024
    local MILLION=1048576

    local vel=$1
    local vel_kb=$(( vel / THOUSAND ))
    local vel_mb=$(( vel / MILLION ))

    if [[ $vel_mb != 0 ]] ; then
        echo -n "$vel_mb MB/s"
    elif [[ $vel_kb != 0 ]] ; then
        echo -n "$vel_kb KB/s";
    else
        echo -n "$vel B/s";
    fi
}

network_interface=$(tmux show-option -gqv "@macos_network_speed_interface")
if [[ -z "$network_interface" ]]; then
  network_interface="en0"
fi

speed_output=$(macos-network-speed en0)
download_speed=$(get_speed $(echo "$speed_output" | grep RX | cut -d: -f2 | awk '{print $1}'))
upload_speed=$(get_speed $(echo "$speed_output" | grep TX | cut -d: -f2 | awk '{print $1}'))

printf "↓ %s ↑ %s" "$download_speed" "$upload_speed"
