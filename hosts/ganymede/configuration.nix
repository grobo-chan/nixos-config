{
  pkgs,
  lib,
  sources,
  ...
}: {
  imports = with (import ../../modules); [
    "${sources.nixos-hardware}/lenovo/legion/16iax10h"
    ./hardware-configuration.nix
    core
    desktop

    gaming
    wireguard
    keepassxc
    editors
    git
    podman
    ollama
    communication
    media
    creative

    kde-connect
    virt-manager
    vnstat

    # disko
    "${sources.disko}/module.nix"
    ./disko.nix

    # preservation
    "${sources.preservation}/module.nix"
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
    extraEntries = ''
      /Windows
      protocol: efi
      path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Secure Boot stuff
  environment.systemPackages = [pkgs.sbctl];
  persistance.sys.directories = ["/var/lib/sbctl"];

  networking.hostName = "ganymede";
  networking.networkmanager.enable = true;

  services.printing.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  specialisation = {
    gaming-time.configuration = {
      hardware.nvidia.prime = {
        sync.enable = true;

        offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };

  services.udisks2.enable = true;
  services.logind.settings.Login.HandleLidSwitch = "poweroff"; # Poweroff when lid is closed

  system.stateVersion = "25.11"; # DO NOT EDIT
}
