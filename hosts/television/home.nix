{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/default.nix
  ];

  home.username = "grobo";
  home.homeDirectory = "/home/grobo";

  home.stateVersion = "25.11"; # DO NOT EDIT

  home.packages = with pkgs; [
    hello
    hello-unfree
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.fish.enable = true;
  programs.keepassxc.enable = true;

  git = {
    enable = true;
    userName = "GroboChan";
    userEmail = "230193800+grobo-chan@users.noreply.github.com";
  };

  zed.enable = false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
