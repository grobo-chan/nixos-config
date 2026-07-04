{
  flake.nixosModules.virtManager = {
    pkgs,
    config,
    ...
  }: let
    user = config.preferences.user.name;
  in {
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };
    programs.virt-manager.enable = true;

    # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752/2
    # add virtiofsd to filesystem xml
    # <binary path="/run/current-system/sw/bin/virtiofsd"/>
    environment.systemPackages = with pkgs; [virtiofsd];

    users.users.${user}.extraGroups = ["libvirtd"];

    persistance.sys.cache.directories = [
      {
        directory = "/var/lib/libvirt";
        mode = "755";
        user = "root";
        group = "root";
      }
    ];
  };
}
