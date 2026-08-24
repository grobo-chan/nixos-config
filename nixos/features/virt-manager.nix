{
  flake.nixosModules.virtManager = {
    pkgs,
    config,
    ...
  }: let
    user = config.preferences.user.name;
  in {
    # If this happens: https://github.com/NixOS/nixpkgs/issues/501336
    # Do this: https://github.com/NixOS/nixpkgs/issues/501336#issuecomment-5404972715

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

    persistance.sys = {
      cache.directories = [
        "/var/lib/libvirt"
      ];
      files = [
        {
          file = "/var/lib/systemd/credential.secret";
          mode = "400";
        }
      ];
    };
  };
}
