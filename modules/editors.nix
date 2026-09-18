{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    vim
    obsidian
  ];
}
