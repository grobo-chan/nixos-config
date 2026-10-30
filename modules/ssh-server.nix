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

    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
}
