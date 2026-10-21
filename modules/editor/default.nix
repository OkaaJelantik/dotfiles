{ config, ... }:
let
  link =
    name: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/configs/${name}";
in
{
  xdg.configFile = {
    "nvim".source = link "nvim";
  };
}
