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

    persistance.user = {
      directories = [
        ".config/GIMP"
        ".config/obs-studio"
        ".local/share/krita"
        ".config/OpenTabletDriver"
      ];

      files = [
        {
          file = ".config/kritadisplayrc";
          mode = "0644";
        }
        {
          file = ".config/kritarc";
          mode = "0600";
        }
        {
          file = ".config/kritashortcutsrc";
          mode = "0600";
        }
      ];

      cache.directories = [
        ".cache/krita"
      ];
    };
  };
}
