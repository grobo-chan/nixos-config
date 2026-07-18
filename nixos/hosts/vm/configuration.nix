{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      self.nixosModules.hostVM
    ];
  };

  flake.nixosModules.hostVM = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      # self.nixosModules.general
      # self.nixosModules.desktop
      # self.nixosModules.git

      # server stuff
      # self.nixosModules.sshServer

      # disko
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.hostVM

      # preservation
      self.nixosModules.preservation
    ];

    users.users.grobo = {
      isNormalUser = true;
      extraGroups = ["networkManager" "wheel"];
      initialPassword = "password";
    };

    persistance = {
      enable = true;
      nukeRoot.enable = true;
    };
    preferences.enableGuest = false;

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

    boot.loader.grub = {
      enable = true;
      devices = ["nodev"];
    };

    networking.hostName = "vm";
    networking.networkmanager.enable = true;

    hardware.enableRedistributableFirmware = true;

    # services = {
    #   qemuGuest.enable = true;
    #   spice-vdagentd.enable = true;
    #   spice-webdavd.enable = true;
    # };

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
