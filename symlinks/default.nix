{ config, ... }:
let
  link =
    name: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/symlinks/${name}";
in
{
  xdg.configFile = {
    "fuzzel".source = link "fuzzel";
    "foot".source = link "foot";
    "rofi".source = link "rofi";
    "swayosd".source = link "swayosd";
    "waybar".source = link "waybar";
    "nvim".source = link "nvim";
    "sway".source = link "sway";
    "zsh".source = link "zsh";
    "aria2".source = link "aria2";
    "yt-dlp".source = link "yt-dlp";
  };
}
