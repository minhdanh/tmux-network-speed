# tmux-network-speed
(Previously `tmux-macos-network-speed`)

Tmux plugin to monitor network stats. Inspired by https://github.com/tmux-plugins/tmux-net-speed

## Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

Add this to `.tmux.conf`:
```
set -g @plugin 'minhdanh/tmux-network-speed'
```

Also add `#{network_speed}` to your left/right status bar.
For example:

```
set -g status-right '#{prefix_highlight} #{network_speed} | CPU: #{cpu_icon}#{cpu_percentage} | %a %Y-%m-%d %H:%M'
```

Then hit `<prefix> + I` to install the plugin.

Sample output:

![sample.png](./sample.png "Sample output")

## Options

In case you want to monitor a network interface other than `en0`, set `network_speed_interface` to the name of that network interface:

```
set -g @network_speed_interface 'enp37s0'
```

Colors for download and upload are supported:

```
set -g @network_speed_download_color '#[fg=green]'
set -g @network_speed_upload_color '#[fg=yellow]'
```

You can also set the format for the speed, it accepts any format string that `printf` supports:
```
set -g @network_speed_format '%05.2f'
```
