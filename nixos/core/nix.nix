{...}: {
  flake.nixosModules.nix = {
    pkgs,
    config,
    ...
  }: {
    imports = [];

    programs.direnv = {
      enable = true;
      silent = false;
      loadInNixShell = true;
      direnvrcExtra = "";
      nix-direnv = {
        enable = true;
      };
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/${config.preferences.user.name}/nixos-config";
    };

    nix.settings = {
      experimental-features = ["nix-command" "flakes" "pipe-operator"];
      trusted-users = ["root" "@wheel" "${config.preferences.user.name}"];
    };
    programs.nix-ld.enable = true;
    nixpkgs.config = {
      allowUnfree = true;
      # cudaSupport = true;
    };

    environment.systemPackages = with pkgs; [
      # Nix tooling
      nil
      nixd
      statix
      alejandra
      manix
      nix-inspect
    ];
  };
}
