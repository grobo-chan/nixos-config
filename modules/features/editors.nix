{
  flake.nixosModules.editors = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kdePackages.kate
      zed-editor
      vim
    ];
  };
}
