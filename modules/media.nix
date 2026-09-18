{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vlc
    strawberry
    kdePackages.okular
  ];
}
