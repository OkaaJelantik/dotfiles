{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    devenv
    inputs.devdash.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
