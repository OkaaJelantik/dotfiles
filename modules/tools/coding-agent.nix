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

  chrome-devtools-mcp = pkgs.stdenv.mkDerivation rec {
    pname = "chrome-devtools-mcp";
    version = "1.12.0";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-${version}.tgz";
      hash = "sha256-Sq3jFnw+eBx5fWEJ7WA6DKW4yzY6KJ4uqsqpsMXSo2A=";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/lib/chrome-devtools-mcp $out/bin
      cp -r * $out/lib/chrome-devtools-mcp/

      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/chrome-devtools \
        --add-flags "$out/lib/chrome-devtools-mcp/build/src/bin/chrome-devtools.js"

      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/chrome-devtools-mcp \
        --add-flags "$out/lib/chrome-devtools-mcp/build/src/bin/chrome-devtools-mcp.js"
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
    chrome-devtools-mcp
    # spec-kit
    openspec
  ];

  home.file.".agents/skills/chrome-devtools-cli".source =
    "${chrome-devtools-mcp}/lib/chrome-devtools-mcp/skills/chrome-devtools-cli";

  xdg.configFile."cd4a/config.json".text = builtins.toJSON {
    executablePath = "/usr/bin/chrome-for-testing";
  };

  programs.nix-skills = {
    enable = true;
    agents = [ "antigravity" ];
  };
}
