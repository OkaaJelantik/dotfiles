#!/bin/bash
profile=$(powerprofilesctl get)
case "$profile" in
    "power-saver") echo "󰌪 SAV" ;;
    "balanced") echo "󰗑 BAL" ;;
    "performance") echo "󱐋 PRF" ;;
    *) echo "$profile" ;;
esac
