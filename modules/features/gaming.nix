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

        package = pkgs.steam.override {
          extraBwrapArgs = [
            "--bind $HOME/.local/share/Valve/Steam $HOME"
            "--unsetenv XDG_CACHE_HOME"
            "--unsetenv XDG_CONFIG_HOME"
            "--unsetenv XDG_DATA_HOME"
            "--unsetenv XDG_STATE_HOME"
          ];
        };
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
    ];
  };
}
