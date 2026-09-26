{
  nix-wrappers,
  config,
  lib,
  ...
}: {
  imports = [
    ./kitty.nix
    (nix-wrappers.lib.getInstallModule {
      name = "niri";
      value = nix-wrappers.lib.wrapperModules.niri;
    })
  ];

  wrappers.niri = {
    enable = true;
    settings = {
      binds = {
        "Mod+T".spawn-sh = lib.getExe config.wrappers.kitty.wrapper;
      };
    };
  };

  programs.niri = {
    package = config.wrappers.niri.wrapper;
    enable = true;
  };
}
