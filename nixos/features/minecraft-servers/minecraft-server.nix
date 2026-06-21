{inputs, ...}: {
  flake.nixosModules.minecraftServer = {pkgs, config, ...}: {
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

    persistance.sys.directories = map (x: {
      directory = x;
      mode = "0770";
      user = "minecraft";
      group = "minecraft";
    }) [
      config.services.minecraft-servers.dataDir
      config.services.minecraft-servers.runDir
    ];
  };
}
