#!/bin/bash
# Retrieve the list of output names
outputs=( $(swaymsg -t get_outputs | jq -r '.[].name') )

workspace=1
for output in "${outputs[@]}"; do
  # Create or move three workspaces to this output
  for i in {1..3}; do
    swaymsg "workspace ${workspace}"
    swaymsg "move workspace to output ${output}"
    workspace=$((workspace + 1))
  done
done

