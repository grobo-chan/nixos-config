{
  sources,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      zen-browser = pkgs.callPackage ./package.nix {
        inherit sources;
        zenPolicies = {
          DisableTelemtry = true;
          DisableFirefoxStudies = true;
          ExtensionSettings = {
            "jid1-ZAdIEUB7XOzOJw@jetpack" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
              installation_mode = "force_installed";
            };
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
          };
        };
      };
    })
  ];

  environment.systemPackages = [pkgs.zen-browser];

  environment.sessionVariables = {
    DEFAULT_BROWSER = lib.getExe pkgs.zen-browser;
    BROWSER = lib.getExe pkgs.zen-browser;
  };

  xdg.mime.defaultApplications = {
    "text/html" = "zen.desktop";
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";
  };

  persistance.user = {
    directories = [".config/zen"];
    cache.directories = [".cache/zen"];
  };
}
