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

      helium = pkgs.callPackage ./packages/helium.nix {
        inherit sources;
        flags = [
          "--restore-last-session"
          "--hide-crash-restore-bubble"
        ];
      };
    })
  ];

  environment.systemPackages = [
    pkgs.tor-browser
    pkgs.qbittorrent
    pkgs.kdePackages.kget
    pkgs.zen-browser
    pkgs.helium
  ];

  programs.chromium = {
    enable = true; # THIS IS NOT THE CHROMIUM BROWSER, IT'S ONLY FOR POLICIES!!!
    extensions = [
      # JSON Viewer
      "gbdbademeighmnbliehmnoifmabbedbp"
      # DDG Extension
      "bkdgflcldnnnapblkhphbgpggdiikppg"
    ];
  };

  xdg.mime.defaultApplications = {
    "text/html" = "zen.desktop";
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";
  };

  persistance.user.directories = [
    ".config/zen"
    ".config/net.imput.helium"
    ".tor project"
    ".config/qBittorrent"
  ];

  persistance.user.cache.directories = [
    ".cache/zen"
    ".cache/net.imput.helium"
    ".cache/tor project"
  ];
}
