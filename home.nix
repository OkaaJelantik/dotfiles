{ ... }:
{
  imports = [
    ./modules
  ];

  home = {
    username = "lann";
    homeDirectory = "/home/lann";
    stateVersion = "26.05";
  };

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
