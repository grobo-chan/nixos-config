{pkgs, ...}: {
  imports = [
    ./helium
    ./zen-browser
  ];

  environment.systemPackages = [
    pkgs.tor-browser
    pkgs.qbittorrent
    pkgs.kdePackages.kget
  ];

  persistance.user.directories = [
    ".tor project"
    ".config/qBittorrent"
  ];

  persistance.user.cache.directories = [
    ".cache/tor project"
  ];
}
