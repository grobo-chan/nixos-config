{
  flake.nixosModules.browsers = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.tor-browser
      pkgs.qbittorrent
      pkgs.kdePackages.kget
    ];

    programs.firefox.enable = true;

    persistance.user.directories = [
      ".mozilla"
      ".config/mozilla"
      ".tor project"
      ".config/qBittorrent"
    ];

    persistance.user.cache.directories = [
      ".cache/mozilla"
      ".cache/tor project"
    ];
  };
}
