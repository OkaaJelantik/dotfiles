{ config, pkgs, ... }:
let
  link =
    name: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/configs/${name}";

  iptv = pkgs.writeShellApplication {
    name = "iptv";
    runtimeInputs = [
      pkgs.fzf
      pkgs.gawk
      pkgs.mpv
    ];
    text = ''
      DATABASE_FILE="''${1:-${./iptv-countries.txt}}"
      SELECTED=$(fzf --prompt="Select Country/Region: " --border=rounded < "$DATABASE_FILE")
      if [ -n "$SELECTED" ]; then
        URL=$(echo "$SELECTED" | awk '{print $NF}')
        mpv "$URL"
      else
        echo "Canceled."
      fi
    '';
  };
in
{
  home.packages = [ iptv ];

  xdg.configFile = {
    "aria2".source = link "aria2";
    "yt-dlp".source = link "yt-dlp";
  };
}
