{
  flake.nixosModules.communication = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      deltachat-desktop
      vesktop
      thunderbird
    ];
  };
}
