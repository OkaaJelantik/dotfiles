{ inputs, pkgs, ... }:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      wayland = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+
      ];
      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
      ];
      enabledSnippets = with spicePkgs.snippets; [
      ];

      #theme = spicePkgs.themes.catppuccin;
      #colorScheme = "mocha";
    };
}
