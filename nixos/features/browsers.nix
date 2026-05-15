{
  flake.nixosModules.browsers = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.tor-browser
      pkgs.ungoogled-chromium
    ];

    programs.firefox.enable = true;

    persistance.user.directories = [
      ".mozilla"
      ".cache/mozilla"
      ".config/chromium"
    ];
  };
}
