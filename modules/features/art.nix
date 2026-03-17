{
  flake.nixosModules.art = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gimp
      krita
    ];
  };
}
