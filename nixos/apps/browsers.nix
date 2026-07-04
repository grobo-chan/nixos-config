{
  flake.nixosModules.browsers = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.tor-browser
      pkgs.qbittorrent
    ];

    programs.firefox.enable = true;

    persistance.user.directories = [
      ".mozilla"
      ".config/mozilla"
    ];

    persistance.user.cache.directories = [
      ".cache/mozilla"
    ];
  };
}
