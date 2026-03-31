{self, ...}: {
  flake.nixosModules.desktop = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.pipewire
      self.nixosModules.browsers
      self.nixosModules.keepassxc
      self.nixosModules.niri
    ];

    services.xserver.enable = true;

    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    services.xserver.xkb = {
      layout = "us";
      variant = "";
      options = "compose:caps";
    };

    time = {
      timeZone = "Asia/Kolkata";
      hardwareClockInLocalTime = true;
    };

    i18n.defaultLocale = "en_IN";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };

    services.upower.enable = true;

    security.polkit.enable = true;

    hardware = {
      enableAllFirmware = true;

      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;

      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
