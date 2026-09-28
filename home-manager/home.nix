{ config, pkgs, ... }:

{
  home.username = "lann";
  home.homeDirectory = "/home/lann";
  home.stateVersion = "26.05";

  home.packages = [
    pkgs.devenv
  ];

  programs.home-manager.enable = true;
}
