{
  flake.nixosModules.editing = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gimp
      krita
      obs-studio
      kdePackages.kdenlive
    ];
  };
}
