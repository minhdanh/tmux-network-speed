#!/bin/bash -

# Function to get a tmux option or return a default value if the option is not set
get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"
	# Check if the option is not set, return the default value if so
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

# Function to calculate the speed in KB/s or MB/s
get_speed() {
	# Constants for conversion
	local THOUSAND=1024
	local MILLION=1048576
	local BILLION=1073741824

	local new=$1
	local current=$2
	local interval=$3
	local vel=0

	# Get the format string for speed display from tmux options
	local format_string=$(get_tmux_option '@network_speed_format' "%05.2f")

	# Calculate the speed if the current value is not zero
	if [ ! "$current" -eq "0" ]; then
		vel=$(echo "$(($new - $current)) $interval" | awk '{print ($1 / $2)}')
	fi

	# Convert speed to KB/s, MB/s, and GB/s
	local vel_kb=$(echo "$vel" $THOUSAND | awk '{print ($1 / $2)}')
	local vel_mb=$(echo "$vel" $MILLION | awk '{print ($1 / $2)}')
	local vel_gb=$(echo "$vel" $BILLION | awk '{print ($1 / $2)}')

	# Check if speed is greater than 99.99 KB/s, then display in MB/s or GB/s
	if (($(echo "$vel_kb > 1024" | bc -l))); then
		if (($(echo "$vel_mb > 1024" | bc -l))); then
			local vel_gb_f=$(printf $format_string $vel_gb)
			printf "%s GB/s" $vel_gb_f
		else
			local vel_mb_f=$(printf $format_string $vel_mb)
			printf "%s MB/s" $vel_mb_f
		fi
	else
		local vel_kb_f=$(printf $format_string $vel_kb)
		printf "%s KB/s" $vel_kb_f
	fi
}

# Function to get the current network speed output for the given interface
get_speed_output() {
	local interface="$1"

	# Check if the operating system is macOS
	if is_osx; then
		# Use netstat for macOS to get transmitted and received bytes
		netstat -bn -I $network_interface | grep "<Link#" | awk '{print $7 " " $10}'
	else
		# Use /proc/net/dev for Linux to get transmitted and received bytes
		cat /proc/net/dev | grep $network_interface | awk '{print $2 " " $10}'
	fi
}

# Function to get the appropriate color based on the raw byte counters
get_speed_color() {
	local new=$1
	local current=$2
	local interval=$3
	local threshold=$4
	local threshold_unit=$5
	local default_color=$6
	local high_color=$7
	local threshold_bytes
	local speed_bytes=0

	# A zero or unset threshold disables high-speed coloring.
	if [ -z "$threshold" ] || ! (($(echo "$threshold > 0" | bc -l))); then
		echo "$default_color"
		return
	fi

	# Convert the configured threshold to bytes per second.
	case "$threshold_unit" in
	"KB/s")
		threshold_bytes=$(echo "$threshold * 1024" | bc -l)
		;;
	"MB/s")
		threshold_bytes=$(echo "$threshold * 1048576" | bc -l)
		;;
	"GB/s")
		threshold_bytes=$(echo "$threshold * 1073741824" | bc -l)
		;;
	*)
		echo "$default_color"
		return
		;;
	esac

	if [ "$current" -ne 0 ] && [ "$interval" -gt 0 ]; then
		speed_bytes=$(echo "($new - $current) / $interval" | bc -l)
	fi

	if (($(echo "$speed_bytes > $threshold_bytes" | bc -l))); then
		echo "$high_color"
	else
		echo "$default_color"
	fi
}

# Function to check if the operating system is macOS
is_osx() {
	[ $(uname) == "Darwin" ]
}
