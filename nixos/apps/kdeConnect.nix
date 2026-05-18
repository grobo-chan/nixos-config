{
  flake.nixosModules.kdeConnect = {pkgs, ...}: {
    programs.kdeconnect.enable = true;
  };
}
