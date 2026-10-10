{ link, ... }:
{
  xdg.configFile = {
    "aria2".source   = link "aria2";
    "fuzzel".source  = link "fuzzel";
    "rofi".source    = link "rofi";
    "swayosd".source = link "swayosd";
    "waybar".source  = link "waybar";
    "nvim".source    = link "nvim";
    "sway".source    = link "sway";
    "zsh".source     = link "zsh";
  };
}
