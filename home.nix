{ pkgs, ... }:
{
  imports = [
    ./symlinks/default.nix
    ./modules/iptv/iptv.nix
  ];
  home = {
    username = "lann";
    homeDirectory = "/home/lann";
    stateVersion = "26.05";
    packages = with pkgs; [
      devenv
    ];
  };
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
