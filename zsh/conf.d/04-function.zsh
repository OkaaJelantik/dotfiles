ytmusic() {
  mpv --no-video --loop-playlist --shuffle --ytdl-raw-options=yes-playlist= --msg-color=yes \
    --term-osd-bar "$1"
}
