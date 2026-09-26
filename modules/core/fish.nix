{
  nix-wrappers,
  pkgs,
  ...
}: {
  imports = [
    (nix-wrappers.lib.getInstallModule {
      name = "fish";
      value = nix-wrappers.lib.wrapperModules.fish;
    })
  ];

  wrappers.fish = {
    configFile.content = ''
      function fish_prompt
          string join "" -- (set_color red) "[" (set_color yellow) $USER (set_color green) "@" (set_color blue) $hostname (set_color magenta) " " $(prompt_pwd) (set_color red) ']' (set_color normal) "\$ "
      end

      set fish_greeting

      if type -q direnv
          direnv hook fish | source
      end
    '';

    shellAliases = {
      ll = "ls -l";
      ls = "ls -a";
    };

    runtimePkgs = with pkgs; [
      file
      unzip
      zip
      p7zip
      rar
      unrar
      wget
      tree
      killall
      sshfs
      fzf
      htop
      btop
      eza
      fd
      dust
      hyfetch
      fastfetch
      tree-sitter
      imagemagick
      imv
      ffmpeg
      yt-dlp
      lazygit
      sops
      age
      jq
      tldr
    ];
  };
}
