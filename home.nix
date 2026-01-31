{ config, pkgs, ... }:

{
  home.username = "grobo";
  home.homeDirectory = "/home/grobo";

  home.stateVersion = "25.11"; # DO NOT EDIT

  home.packages = [

  ];

  home.file = {
  
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.fish.enable = true;
  programs.keepassxc.enable = true;  
  programs.vesktop.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
