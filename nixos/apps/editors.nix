{
  flake.nixosModules.editors = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kdePackages.kate
      zed-editor
      vim
      obsidian
    ];

    persistance.user = {
      directories = [
        ".config/zed"
        ".local/share/zed"
      ];

      cache.directories = [
        ".cache/zed"
      ];
    };
  };
}
