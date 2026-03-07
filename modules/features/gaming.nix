{
  flake.nixosModules.gaming = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) mkDefault;
  in {
    hardware.graphics.enable = mkDefault true;

    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        extraPackages = with pkgs; [
          SDL2
          gamescope
        ];
        protontricks.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      lutris
      steam-run
      dxvk
      gamescope
      mangohud
      heroic
      bottles
      steamtinkerlaunch
      prismlauncher
      lsfg-vk
      lsfg-vk-ui
    ];
  };
}
