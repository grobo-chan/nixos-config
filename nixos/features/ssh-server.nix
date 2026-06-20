{
  flake.nixosModules.sshServer = {config, ...}: {
    services.openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = ["${config.preferences.user.name}"];
      };
    };

    services.fail2ban.enable = true;

    persistance.sys.files = map (x: {
      file = x;
      mode = "0600";
    }) [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
