{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.europa = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      self.nixosModules.hostEuropa
    ];
  };

  flake.nixosModules.hostEuropa = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop
      self.nixosModules.git
      self.nixosModules.editors

      # server stuff
      self.nixosModules.sshServer

      # disko
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.hostEuropa

      # preservation
      self.nixosModules.preservation
    ];

    persistance = {
      enable = true;
      nukeRoot = {
        enable = true;
        volumeGroup = "mapper/cryptroot";
      };
    };

    boot = {
      # silence first boot output
      consoleLogLevel = 3;
      initrd.verbose = false;
      initrd.systemd.enable = true;
      kernelParams = [
        "quiet"
        "splash"
        "intremap=on"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];

      # plymouth, showing after LUKS unlock
      plymouth = {
        enable = true;
        font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
        logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
      };
    };

    boot.loader.limine = {
      enable = true;
      efiSupport = true;
      secureBoot.enable = true;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    # Secure Boot stuff
    environment.systemPackages = [pkgs.sbctl];
    persistance.sys.directories = ["/var/lib/sbctl"];

    networking.hostName = "europa";
    networking.networkmanager.enable = true;

    services.udisks2.enable = true;
    hardware.enableRedistributableFirmware = true;

    services.logind.settings.Login.HandleLidSwitch = "ignore"; # Do nothing when Lid is closed

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
