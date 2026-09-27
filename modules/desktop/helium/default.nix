{
  sources,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      helium = pkgs.callPackage ./package.nix {
        inherit sources;
        flags = [
          "--restore-last-session"
          "--hide-crash-restore-bubble"
        ];
      };
    })
  ];

  environment.systemPackages = [pkgs.helium];

  programs.chromium = {
    enable = true; # THIS IS NOT THE CHROMIUM BROWSER, IT'S ONLY FOR POLICIES!!!
    extensions = [
      # JSON Viewer
      "gbdbademeighmnbliehmnoifmabbedbp"
      # DDG Extension
      "bkdgflcldnnnapblkhphbgpggdiikppg"
    ];
  };

  persistance.user = {
    directories = [".config/net.imput.helium"];
    cache.directories = [".cache/net.imput.helium"];
  };
}
