{
  flake.nixosModules.keepassxc = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];

    persistance.user = {
      directories = [
        ".config/keepassxc"
      ];
      cache.directories = [
        ".cache/keepassxc"
      ];
    };
  };
}
