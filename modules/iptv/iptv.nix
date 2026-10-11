{ pkgs, ... }:
let
  iptv = pkgs.writeShellApplication {
    name = "iptv";
    text = ''
      DATABASE_FILE="''${1:-/home/lann/Dotfiles/modules/iptv/iptv-countries.txt}"
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
}
