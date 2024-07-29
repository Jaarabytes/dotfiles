#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown


# Get the list of windows with their workspace and titles
i3-msg -t get_tree | jq -r '
  .nodes[].nodes[].nodes[] |
  select(.type == "workspace") |
  .name as $workspace |
  .nodes[] |
  select(.nodes[].name != "__i3_scratch") |
  .nodes[] |
  {name: .name, window: .window_properties.class, workspace: $workspace} |
  "\($workspace): \(.window) - \(.name)"'


echo "Polybar launched..."
