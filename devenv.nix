{
  pkgs,
  ...
}:
{
  packages = with pkgs; [
    nil
    statix
    lua-language-server
  ];

  treefmt = {
    enable = true;
    config = {
      projectRootFile = "flake.nix";
      programs = {
        nixfmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        stylua.enable = true;
      };
    };
  };

  scripts.format.exec = "treefmt";
  scripts.nixlint.exec = ''
    treefmt --fail-on-change
    statix check .
  '';
}
