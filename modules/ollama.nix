{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "gemma4:e4b"
      "gemma4:26b"
      "gemma4:31b"
    ];
  };

  # Temporarily disabled
  # Wait until: https://github.com/NixOS/nixpkgs/pull/575801 is merged
  services.open-webui = {
    enable = false;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      # Disable authentication
      WEBUI_AUTH = "False";
    };
  };

  persistance.sys.directories = [
    {
      directory = "/var/lib/ollama";
      how = "symlink";
      user = "ollama";
      group = "ollama";
    }
  ];
}
