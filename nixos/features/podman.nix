{
  flake.nixosModules.podman = {pkgs, ...}: {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      containers = {
        registries.settings = {
          registry = [
            {
              location = "docker.io";
            }
            {
              location = "quay.io";
            }
          ];
        };

        storage.settings = {
          storage = {
            driver = "btrfs";
            graphroot = "/var/lib/containers/storage";
            runroot = "/run/containers/storage";
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      dive
      podman-desktop
      podman-compose
    ];

    persistance.user.cache.directories = [".local/share/containers"];
  };
}
