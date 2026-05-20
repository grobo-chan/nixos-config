{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    inherit
      (lib)
      getExe
      ;
  in {
    packages.nix-check-bin = pkgs.writeShellApplication {
      name = "nix-check-bin";
      text = ''
        $EDITOR "$(nix build "$1" --no-link --print-out-paths)/bin"
      '';
    };

    packages.environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
        # nix
        pkgs.nil
        pkgs.nixd
        pkgs.statix
        pkgs.alejandra
        pkgs.manix
        pkgs.nix-inspect

        # other
        pkgs.file
        pkgs.unzip
        pkgs.zip
        pkgs.p7zip
        pkgs.wget
        pkgs.tree
        pkgs.killall
        pkgs.sshfs
        pkgs.fzf
        pkgs.htop
        pkgs.btop
        pkgs.eza
        pkgs.fd
        pkgs.zoxide
        pkgs.dust
        pkgs.ripgrep
        pkgs.hyfetch
        pkgs.fastfetch
        pkgs.tree-sitter
        pkgs.imagemagick
        pkgs.imv
        pkgs.ffmpeg
        pkgs.yt-dlp
        pkgs.lazygit
        pkgs.gh
        pkgs.sops
        pkgs.age

        # wrapped
        self'.packages.git
        self'.packages.lf
      ];
      env = {
        EDITOR = "vim";
      };
    };
  };
}
