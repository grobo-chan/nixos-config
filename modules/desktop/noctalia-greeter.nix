{config, ...}:
let
  user = config.preferences.user.name;
in {
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = [ user ];
    settings = {
      keyboard.layout = "us";
    };
  };
}
