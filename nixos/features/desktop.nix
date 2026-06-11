{self, ...}: {
  flake.nixosModules.desktop = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.pipewire
      self.nixosModules.browsers
      self.nixosModules.keepassxc
      self.nixosModules.niri
      self.nixosModules.sddm
    ];

    services.xserver.enable = true;

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
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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

    services.gnome.gnome-keyring.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk];
    };

    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    environment.systemPackages = [
      pkgs.kdePackages.dolphin
      pkgs.ddcutil

      # run gparted with all the permissions crap fixed, I don't want it permanently installed
      (pkgs.writeShellApplication {
        name = "gparted";
        # fix Authorization required, but no authorization protocol specified error
        # fix gparted "cannot open display: :0" error
        # respectively
        text =
          /*
          sh
          */
          ''
            nix-shell -p xhost gparted ntfs3g --command "xhost si:localuser:root && xhost +local:${config.preferences.user.name} && sudo gparted"
          '';
      })

      # similar to the gparted one but for fedora mediawriter
      (pkgs.writeShellApplication {
        name = "mediawriter";
        text =
          /*
          sh
          */
          ''
            nix-shell -p mediawriter --command "sudo -E mediawriter"
          '';
      })
    ];
  };
}
