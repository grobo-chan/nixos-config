{
  config,
  pkgs,
  ...
}: {
  home.username = "grobo";
  home.homeDirectory = "/home/grobo";

  home.stateVersion = "25.11"; # DO NOT EDIT

  home.packages = with pkgs; [
    hello
    hello-unfree
    gimp-with-plugins
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.fish.enable = true;
  programs.keepassxc.enable = true;
  programs.vesktop.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "GroboChan";
        email = "230193800+grobo-chan@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
    lfs.enable = true;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "toml" "rust"];
    userSettings = {
      theme = {
        mode = "system";
        dark = "One Dark";
        light = "One Light";
      };
      hour_format = "hour24";
      vim_mode = true;
      languages = {
        Nix = {
          language_servers = ["nixd" "!nil"];
          formatter = {
            external = {
              command = "alejandra";
              arguments = ["--quiet" "--"];
            };
          };
        };
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
