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

    # solution to this issue: https://github.com/NixOS/nixpkgs/issues/501336
    systemd.services.virtFix = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      before = [ "libvirtd.service" ];

      script = ''rm -f /var/lib/libvirt/secrets/secrets-encryption-key'';
    };

    users.users.${user}.extraGroups = ["libvirtd"];

    persistance.sys.cache.directories = ["/var/lib/libvirt"];
  };
}
