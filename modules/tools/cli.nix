{ pkgs, ... }:
{
  home.packages = with pkgs; [
    devenv
    lazydocker
    lazygit
    nix-search-cli

    (pkgs.python3.withPackages (
      ps: with ps; [
        markitdown
        python-pptx
      ]
    ))
  ];
}
