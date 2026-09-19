{
  core = import ./core;
  desktop = import ./desktop;

  communication = import ./communication.nix;
  creative = import ./creative.nix;
  editors = import ./editors.nix;
  gaming = import ./gaming.nix;
  git = import ./git.nix;
  kde-connect = import ./kde-connect.nix;
  keepassxc = import ./keepassxc.nix;
  media = import ./media.nix;
  ollama = import ./ollama.nix;
  podman = import ./podman.nix;
  ssh-server = import ./ssh-server.nix;
  virt-manager = import ./virt-manager.nix;
  vnstat = import ./vnstat.nix;
  wireguard = import ./wireguard.nix;
}
