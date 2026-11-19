{ config, ... }:
let
  configEntries = builtins.readDir ./configs;
in
{
  imports = [
    ./modules
  ];

  home = {
    username = "lann";
    homeDirectory = "/home/lann";
    stateVersion = "26.05";
  };

  xdg.configFile = builtins.mapAttrs (name: _: {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/configs/${name}";
  }) configEntries;

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
}
