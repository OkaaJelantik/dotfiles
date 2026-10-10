{ config, ... }:
{
  _module.args.link =
    name: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/Symlinks/${name}";

  imports = [
    ./packages.nix
    ./Symlinks/symlinks.nix
  ];

  home = {
    username = "lann";
    homeDirectory = "/home/lann";
    stateVersion = "26.05";
  };
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
