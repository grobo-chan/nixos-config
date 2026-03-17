{
  flake.nixosModules.browsers = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.tor-browser
    ];

    programs.firefox.enable = true;
  };
}
