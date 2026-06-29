{
  flake.nixosModules.browsers = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.tor-browser
      pkgs.qbittorrent
    ];

    programs.firefox.enable = true;

    persistance.user.directories = [
      ".mozilla"
      ".cache/mozilla"
      ".config/mozilla"
    ];
  };
}
