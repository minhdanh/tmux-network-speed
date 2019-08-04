# tmux-macos-network-speed

Tmux plugin to monitor network stats on macOS. Inspired by https://github.com/tmux-plugins/tmux-net-speed

## Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

This plugin is supposed to be used with [macos-network-speed](https://github.com/minhdanh/macos-network-speed). Please refer to that repo to install the command `macos-network-speed` first.

Add this to `.tmux.conf`:
```
set -g @plugin 'minhdanh/tmux-macos-network-speed'
```

Also add `#{network_speed}` to your left/right status bar.
For example:

```
set -g status-right '#{prefix_highlight} #{network_speed} | CPU: #{cpu_icon}#{cpu_percentage} | %a %Y-%m-%d %H:%M'
```

Then hit `<prefix> + I` to install the plugin.

Sample output:

```
↓ 25 MB/s ↑ 102 KB/s
```
