#!/bin/bash -

# Get the directory of the current script
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the helper functions from helpers.sh
source "$CURRENT_DIR/helpers.sh"

# Retrieve tmux options for upload and download colors, set default if not found
default_upload_color="$(get_tmux_option "@network_speed_upload_color" "#[fg=yellow]")"
default_download_color="$(get_tmux_option "@network_speed_download_color" "#[fg=green]")"

# Retrieve tmux options for speed threshold, unit and high speed color, set default if not found
threshold_speed="$(get_tmux_option "@network_speed_threshold" "0")"
threshold_unit="$(get_tmux_option "@network_speed_threshold_unit" "MB/s")"
high_speed_color="$(get_tmux_option "@network_speed_high_color" "#[fg=red]")"

# Retrieve the network interface and current transmitted (tx) and received (rx) byte counts from tmux options
network_interface=$(get_tmux_option "@network_speed_interface" "en0")
current_tx=$(get_tmux_option "@network_speed_tx" 0)
current_rx=$(get_tmux_option "@network_speed_rx" 0)

# Get the current speed output for the network interface
speed_output=$(get_speed_output $network_interface)
new_rx=$(echo "$speed_output" | awk '{print $1}') # Extract the new received bytes
new_tx=$(echo "$speed_output" | awk '{print $2}') # Extract the new transmitted bytes

# Update tmux options with the new transmitted and received byte counts
tmux set-option -gq "@network_speed_tx" $new_tx
tmux set-option -gq "@network_speed_rx" $new_rx

# Get the current time in seconds since epoch
cur_time=$(date +%s)

# Retrieve the last update times for tx and rx from tmux options, default to 0 if not found
last_update_time_tx=$(get_tmux_option '@network_speed_last_update_time_tx' 0)
interval_tx=$((cur_time - last_update_time_tx))
last_update_time_rx=$(get_tmux_option '@network_speed_last_update_time_rx' 0)
interval_rx=$((cur_time - last_update_time_rx))

# Calculate upload speed if the interval is non-zero, otherwise use the last recorded speed
if [ $interval_tx -eq 0 ]; then
	upload_speed=$(get_tmux_option '@network_speed_last_speed_tx')
else
	upload_speed=$(get_speed $new_tx $current_tx $interval_tx)
	tmux set-option -gq "@network_speed_last_speed_tx" "$upload_speed"
	tmux set-option -gq "@network_speed_last_update_time_tx" $(date +%s)
fi

# Calculate download speed if the interval is non-zero, otherwise use the last recorded speed
if [ $interval_rx -eq 0 ]; then
	download_speed=$(get_tmux_option '@network_speed_last_speed_rx')
else
	download_speed=$(get_speed $new_rx $current_rx $interval_rx)
	tmux set-option -gq "@network_speed_last_speed_rx" "$download_speed"
	tmux set-option -gq "@network_speed_last_update_time_rx" $(date +%s)
fi

# Determine the color for download and upload speeds based on the threshold, unit, and high speed color settings
download_color=$(get_speed_color "$download_speed" "$threshold_speed" "$threshold_unit" "$default_download_color" "$high_speed_color")
upload_color=$(get_speed_color "$upload_speed" "$threshold_speed" "$threshold_unit" "$default_upload_color" "$high_speed_color")

# Print the download and upload speeds with the appropriate colors
printf "%s↓ %s#[fg=default] %s↑ %s#[fg=default]" "$download_color" "$download_speed" "$upload_color" "$upload_speed"
