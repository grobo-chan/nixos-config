{
  flake.nixosModules.creative = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gimp
      krita
      obs-studio
      kdePackages.kdenlive
    ];

    hardware.opentabletdriver.enable = true;
    hardware.uinput.enable = true;
  };
}
