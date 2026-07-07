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
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };

    # See: https://github.com/NixOS/nixpkgs/issues/514113#issuecomment-4338976393
    nixpkgs.overlays = [
      (_: prev: {
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
    ];

    environment.systemPackages = with pkgs; [
      lutris
      bottles
      steam-run
      dxvk
      mangohud
      steamtinkerlaunch
      prismlauncher
      lsfg-vk
      lsfg-vk-ui
      archipelago
      melonds
      mgba

      wine
      wine64
      umu-launcher
      heroic
    ];

    persistance.user.directories = [
      ".local/share/Steam"
      ".local/share/lutris"
      ".local/share/bottles"
      ".local/share/PrismLauncher"
      ".local/share/Terraria"
      ".local/share/Paradox Interactive"
      ".local/share/Archipelago"
    ];

    persistance.user.cache.directories = [
      ".cache/lutris"
    ];
  };
}
