{
  flake.nixosModules.vnstat = {
    services.vnstat.enable = true;
    persistance.sys.directories = ["/var/lib/vnstat"];
  };
}
