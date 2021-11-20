#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

default_download_color="#[fg=green]"
default_upload_color="#[fg=yellow]"

get_speed()
{
    # Consts
    local THOUSAND=1024
    local MILLION=1048576

    local new=$1
    local current=$2
    local vel=0

    local interval=$(get_tmux_option 'status-interval' 3)
    local format_string=$(get_tmux_option '@network_speed_format' "%05.2f")

    if [ ! "$current" -eq "0" ]; then
      vel=$(echo "$(( $new - $current )) $interval" | awk '{print ($1 / $2)}')
    fi

    local vel_kb=$(echo "$vel" $THOUSAND | awk '{print ($1 / $2)}')
    local vel_mb=$(echo "$vel" $MILLION | awk '{print ($1 / $2)}')

    result=$(printf "%05.2f > 99.99\n" $vel_kb | bc -l)
    if [[ $result == 1 ]]; then
        local vel_mb_f=$(printf $format_string $vel_mb)
        printf "%s MB/s" $vel_mb_f
    else
        local vel_kb_f=$(printf $format_string $vel_kb)
        printf "%s KB/s" $vel_kb_f
    fi
}

network_interface=$(get_tmux_option "@network_speed_interface" "en0")
c_tx=$(get_tmux_option "@network_speed_tx" 0)
c_rx=$(get_tmux_option "@network_speed_rx" 0)

speed_output=$(get_speed_output $network_interface)
n_rx=$(echo "$speed_output" | awk '{print $1}')
n_tx=$(echo "$speed_output" | awk '{print $2}')
tmux set-option -gq "@network_speed_tx" $n_tx
tmux set-option -gq "@network_speed_rx" $n_rx

upload_speed=$(get_speed $n_tx $c_tx)
download_speed=$(get_speed $n_rx $c_rx)

download_color=$(get_tmux_option "@network_speed_download_color" "$default_download_color")
upload_color=$(get_tmux_option "@network_speed_upload_color" "$default_upload_color")

printf "%s↓ %s %s↑ %s#[fg=default]" "$download_color" "$download_speed" "$upload_color" "$upload_speed"
