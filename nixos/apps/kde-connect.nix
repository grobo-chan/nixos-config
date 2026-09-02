{
  flake.nixosModules.kdeConnect = {...}: {
    programs.kdeconnect.enable = true;

    persistance.user.directories = [
      ".config/kdeconnect"
    ];

    persistance.user.cache.directories = [
      ".cache/kdeconnect.app"
      ".cache/kdeconnect.daemon"
    ];
  };
}
