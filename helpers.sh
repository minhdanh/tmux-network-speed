#!/bin/bash -

get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

get_speed_output() {
	local interface="$1"

	if is_osx; then
		netstat -bn -I $network_interface | grep "<Link#" | awk '{print $7 " " $10}'
	else
		cat /proc/net/dev | grep $network_interface | awk '{print $2 " " $10}'
	fi
}

is_osx() {
    [ $(uname) == "Darwin" ]
}
