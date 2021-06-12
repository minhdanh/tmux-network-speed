#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

network_speed="#($CURRENT_DIR/network_speed.sh)"
network_interpolation="\#{network_speed}"

main() {
    status_right=$(tmux show-option -gqv "status-right")
    status_left=$(tmux show-option -gqv "status-left")

    status_right=${status_right/$network_interpolation/$network_speed}

    status_left=${status_left/$network_interpolation/$network_speed}

    tmux set-option -gq "status-right" "$status_right"
    tmux set-option -gq "status-left" "$status_left"
}
main
