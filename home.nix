{ config, pkgs, ... }:
{
  _module.args.link = name:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Dotfiles/${name}";

  imports = [
    ./modules/packages.nix
    ./modules/temp.nix
    ./modules/default.nix
  ];

  home.username = "lann";
  home.homeDirectory = "/home/lann";
  home.stateVersion = "26.05";
  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;
}
