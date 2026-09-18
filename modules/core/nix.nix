{
  sources,
  pkgs,
  config,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      inherit
        (final.lixPackageSets.stable)
        nixpkgs-review
        # nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;

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
  };
  environment.variables = {
    "NH_FILE" = "/etc/nixos/system.nix";
    "NH_ATTRP" = config.networking.hostName;
  };

  nix.channel.enable = false;
  environment.etc = {
    "nixos/nixpkgs".source = builtins.storePath pkgs.path;
    "nixos/rust-overlay".source = sources.rust-overlay;
  };
  nix.nixPath = [
    "nixpkgs=/etc/nixos/nixpkgs"
    "rust-overlay=/etc/nixos/rust-overlay"
  ];

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by nixos.
  nix.registry.nixpkgs.flake = sources.nixpkgs;

  nix.settings = {
    experimental-features = ["nix-command" "pipe-operator"];
    trusted-users = ["root" "@wheel"];

    extra-substituters = ["https://cache.nixos-cuda.org"];
    extra-trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
  };
  programs.nix-ld.enable = true;

  persistance.user.files = [
    ".local/share/nix/trusted-settings.json"
  ];

  environment.systemPackages = with pkgs; [
    # Nix tooling
    nil
    nixd
    statix
    alejandra
    manix
    nix-inspect
  ];
}
