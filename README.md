# tmux-network-speed

(Previously `tmux-macos-network-speed`)

Tmux plugin to monitor network stats. Inspired by https://github.com/tmux-plugins/tmux-net-speed

## Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

Add this to `.tmux.conf`:

```sh
set -g @plugin 'minhdanh/tmux-network-speed'
```

Also add `#{network_speed}` to your left/right status bar.
For example:

```sh
set -g status-right '#{prefix_highlight} #{network_speed} | CPU: #{cpu_icon}#{cpu_percentage} | %a %Y-%m-%d %H:%M'
```

Then hit `<prefix> + I` to install the plugin.

Sample output:

![sample.gif](./sample.gif "Sample output")

## Options

### Network Interface

In case you want to monitor a network interface other than `en0`, set `network_speed_interface` to the name of that network interface:

```sh
set -g @network_speed_interface 'enp37s0'
```

### Colors

Colors for download and upload are supported:

```sh
set -g @network_speed_download_color '#[fg=green]'
set -g @network_speed_upload_color '#[fg=yellow]'
```

### Speed Format

You can also set the format for the speed, it accepts any format string that `printf` supports:

```sh
set -g @network_speed_format '%05.2f'
```

### High-Speed Threshold and Color

You can set a threshold speed above which the color will change to indicate high speed. The default threshold is 1.0 MB/s.

Set the high-speed threshold:

```sh
set -g @network_speed_threshold '1.0'
```

Set the color for high speed:

```sh
set -g @network_speed_high_color '#[fg=red]'
```

### High-Speed Threshold Unit

You can specify the unit for the high-speed threshold. Supported units are `KB/s`, `MB/s`, and `GB/s`. The default unit is `MB/s`.

Set the high-speed threshold unit:

```sh
set -g @network_speed_threshold_unit 'MB/s'
```
