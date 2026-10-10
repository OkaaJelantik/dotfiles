{ config, ... }:
{
  _module.args.link =
    name: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Dotfiles/Symlinks/${name}";

  imports = [
    ./modules/packages.nix
    ./modules/symlinks.nix
    ./modules/default.nix
  ];

  home = {
    username = "lann";
    homeDirectory = "/home/lann";
    stateVersion = "26.05";
  };
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
