{nix-wrappers, ...}: {
  imports = [
    (nix-wrappers.lib.getInstallModule {
      name = "kitty";
      value = nix-wrappers.lib.wrapperModules.kitty;
    })
  ];

  wrappers.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };

    settings = {
      cursor_text_color = "background";
      allow_remote_control = "yes";
      shell_integration = "enabled";
      cursor_trail = 3;
    };

    keybindings = {
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      "alt+6" = "goto_tab 6";
      "alt+7" = "goto_tab 7";
      "alt+8" = "goto_tab 8";
      "alt+9" = "goto_tab 9";
      "ctrl+shift+w" = "close_tab";
      "ctrl+t" = "new_tab_with_cwd";
      "ctrl+shift+t" = "new_tab";
    };
  };
}
