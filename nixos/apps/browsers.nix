{
  flake.nixosModules.browsers = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.tor-browser
      pkgs.ungoogled-chromium
      pkgs.qbittorrent
    ];

    programs.firefox.enable = true;

    persistance.user.directories = [
      ".mozilla"
      ".cache/mozilla"
      ".config/mozilla"
      ".config/chromium"
    ];
  };
}
