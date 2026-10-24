#!/usr/bin/env bash
# Smart close: if focused window is Spotify, hide to scratchpad instead of killing.

FOCUSED=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .app_id // .window_properties.class // empty' | tr '[:upper:]' '[:lower:]')

if [ "$FOCUSED" = "spotify" ]; then
  swaymsg move scratchpad
else
  swaymsg kill
fi
