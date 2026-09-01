{
  flake.nixosModules.wireguard = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      wireguard-tools
      eddie
    ];

    networking.firewall = {
      allowedUDPPorts = [51820];
    };

    networking.wg-quick.interfaces.wg0 = {
      listenPort = 51820;
      autostart = false;
      configFile = "/etc/wireguard/wg0.conf";
    };

    persistance.sys.files = [
      {
        file = "/etc/wireguard/wg0.conf";
        mode = "0400";
        how = "symlink";
      }
    ];
  };
}
