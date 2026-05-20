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
  };
}
