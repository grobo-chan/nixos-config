{inputs, ...}: {
  flake.nixosModules.minecraftServer = {pkgs, ...}: {
    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      # NOTE: Make sure to start all file names with _
      # Or else the flake.nix file will try to read it as a flake parts module
      servers = {
        archipelago = import ./_archipelago.nix { inherit pkgs; };
      };
    };
  };
}
