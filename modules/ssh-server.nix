{config, ...}: {
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin =
        if config.networking.hostName == "vm"
        then "yes"
        else "no";
      AllowUsers = ["${config.preferences.user.name}"];
    };
  };

  services.fail2ban.enable = true;
  persistance.sys.files =
    [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ]
    |> map (
      file: {
        inherit file;
        mode = "0400";
      }
    );
}
