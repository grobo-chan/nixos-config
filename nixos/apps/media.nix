{
  flake.nixosModules.media = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      vlc
      strawberry
    ];
  };
}
