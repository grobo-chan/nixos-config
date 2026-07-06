{ self, inputs, ... }: {
  flake.nixosModules.hm = { pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

  flake.homeModules.mainUserModule = { pkgs, ... }: {
    programs.fish.enable = true;
    programs.kitty.enable = true;

    home.packages = [ pkgs.hello ];
    home.stateVersion = "25.11"; # DO NOT EDIT
  };
}
