{ inputs, ... }:
{
  imports = [ inputs.arkenfox.modules.homeManager.arkenfox ];

  programs.firefox = {
    enable = true;
    package = null;

    arkenfox = {
      enable = true;
      version = "140.0";

      profiles.arkenfox = {
        enableAllSections = true;

        settings = {
          "0100" = {
            "0102".value = 3;
            enable = true;
          };
          "0300" = {
            enable = true;
            "0335".enable = false; # Disable Firefox Home telemetry
          };
          "1200" = {
            enable = true;
            "1201"."security.ssl.require_safe_negotiation".value = false;
          };
        };
      };
    };
  };
}
