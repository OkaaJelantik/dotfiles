{ pkgs, ... }:
{
  home.packages = with pkgs; [
    devenv
    markitdown
    lazydocker
    lazygit
  ];
}
