{ config, ... }:
let
  link =
    name: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/configs/${name}";
in
{
  xdg.configFile = {
    "foot".source = link "foot";
    "fuzzel".source = link "fuzzel";
    "rofi".source = link "rofi";
    "sway".source = link "sway";
    "swayosd".source = link "swayosd";
    "waybar".source = link "waybar";
  };
}
