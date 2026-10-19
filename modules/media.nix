{pkgs, nix-wrappers, ...}: {
  imports = [
    (nix-wrappers.lib.getInstallModule {
      name = "mpv";
      value = nix-wrappers.lib.wrapperModules.mpv;
    })
  ];

  wrappers.mpv = {
    enable = true;
    "mpv.conf".content = ''
      sub-visibility=no
    '';
  };

  environment.systemPackages = with pkgs; [
    vlc
    strawberry
    kdePackages.okular
  ];

  persistance.user.directories = [
    ".config/vlc"
  ];
}
