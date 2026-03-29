{
  flake.nixosModules.sshServer = {...}: {
    services.openssh = {
      enable = true;
      ports = [6543];
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = ["grobo"];
      };
    };

    services.fail2ban.enable = true;
  };
}
