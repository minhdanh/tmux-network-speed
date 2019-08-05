#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_speed()
{
    # Consts
    local THOUSAND=1024
    local MILLION=1048576

    local new=$1
    local current=$2
    local vel=0

    local interval=$(tmux show-option -gqv 'status-interval')
    if [[ -z "$interval" ]]; then
      interval=3
    fi

    if [ ! "$current" -eq "0" ]; then
      vel=$(( ( $new - $current ) / $interval ))
    fi

    local vel_kb=$(( vel / THOUSAND ))
    local vel_mb=$(( vel / MILLION ))

    if [[ $vel_mb != 0 ]] ; then
        printf "%02d MB/s" $vel_mb
    else
        printf "%02d KB/s" $vel_kb
    fi
}

network_interface=$(tmux show-option -gqv "@macos_network_speed_interface")
c_tx=$(tmux show-option -gqv "@macos_network_speed_tx")
c_rx=$(tmux show-option -gqv "@macos_network_speed_rx")

if [[ -z "$network_interface" ]]; then
  network_interface="en0"
fi

if [[ -z "$c_tx" ]]; then
  c_tx=0
fi

if [[ -z "$c_rx" ]]; then
  c_rx=0
fi

speed_output=$(macos-network-speed en0)
n_tx=$(echo "$speed_output" | grep RX | cut -d: -f2 | awk '{print $1}')
n_rx=$(echo "$speed_output" | grep TX | cut -d: -f2 | awk '{print $1}')
tmux set-option -gq "@macos_network_speed_tx" $n_tx
tmux set-option -gq "@macos_network_speed_rx" $n_rx

upload_speed=$(get_speed $n_tx $c_tx)
download_speed=$(get_speed $n_rx $c_rx)

printf "↓ %s ↑ %s" "$download_speed" "$upload_speed"
