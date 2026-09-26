{
  config,
  nix-wrappers,
  ...
}: {
  imports = [
    (nix-wrappers.lib.getInstallModule {
      name = "nh";
      value = nix-wrappers.lib.wrapperModules.nh;
    })
  ];

  wrappers.nh = {
    env = {
      "NH_FILE" = "/etc/nixos/system.nix";
      "NH_ATTRP" = config.networking.hostName;
    };
  };

  programs.nh = {
    package = config.wrappers.nh.wrapper;
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };
}
