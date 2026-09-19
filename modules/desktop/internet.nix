{
  sources,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      zen-browser = pkgs.callPackage ./packages/zen-browser.nix {
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

  environment.systemPackages = [
    pkgs.tor-browser
    pkgs.qbittorrent
    pkgs.kdePackages.kget
    pkgs.zen-browser
  ];

  xdg.mime.defaultApplications = {
    "text/html" = "zen.desktop";
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";
  };

  persistance.user.directories = [
    ".config/zen"
    ".tor project"
    ".config/qBittorrent"
  ];

  persistance.user.cache.directories = [
    ".cache/zen"
    ".cache/tor project"
  ];
}
