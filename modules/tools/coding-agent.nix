{ inputs, pkgs, ... }:
let
  tgrep-mcp = pkgs.stdenv.mkDerivation rec {
    pname = "tgrep-mcp";
    version = "0.3.1";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/tgrep-mcp/-/tgrep-mcp-${version}.tgz";
      hash = "sha256-eNK0mhaGy05ER0vh4JBED/zXCIZWcqMgoL5KPpzeS3Y=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/lib/tgrep-mcp $out/bin
      cp -r * $out/lib/tgrep-mcp/
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/tgrep-mcp \
        --add-flags "$out/lib/tgrep-mcp/server.mjs"
    '';
  };
in
{
  imports = [
    inputs.nix-skills.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    graphify
    litellm
    tgrep
    tgrep-mcp
    spec-kit
  ];

  programs.nix-skills = {
    enable = true;
    agents = [ "antigravity" ];
  };
}
