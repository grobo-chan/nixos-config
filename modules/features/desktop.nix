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

    services.xserver.xkb = {
      layout = "us";
      variant = "";
      options = "compose:caps";
    };

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      ubuntu-sans
      cm_unicode
      corefonts
      unifont
    ];

    fonts.fontconfig.defaultFonts = {
      serif = ["Ubuntu Sans"];
      sansSerif = ["Ubuntu Sans"];
      monospace = ["JetBrainsMono Nerd Font"];
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

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk pkgs.gnome-keyring];
      config = {
        niri = {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Access" = ["gtk"];
          "org.freedesktop.impl.portal.Notification" = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
      };
    };

    xdg.mime.addedAssociations = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };

    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.dolphin
    ];
  };
}
