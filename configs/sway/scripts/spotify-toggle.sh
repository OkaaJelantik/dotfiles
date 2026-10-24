#!/usr/bin/env bash
# Toggle Spotify scratchpad window. If not running, launch it.

if swaymsg -t get_tree | grep -qiE '"app_id": *"spotify"|"class": *"Spotify"'; then
  swaymsg '[app_id="(?i)spotify"] scratchpad toggle' 2>/dev/null ||
    swaymsg '[class="(?i)spotify"] scratchpad toggle' 2>/dev/null
else
  spotify &
fi
