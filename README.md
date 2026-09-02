## Devices List
All Devices are named after the moons of Jupiter in order of discovery. <br />
(Io was skipped to avoid confusion with I/O (Input/Output)) <br />
https://en.wikipedia.org/wiki/Moons_of_Jupiter#List

| Hostname | Device Model  | Notes |
| --- | --- | --- |
| Europa | Dell Inspiron 15 5000 | N/A |
| Ganymede | Lenovo Legion Pro 7 16IAX10H | Uses [@nadimkobeissi's audio patch](https://github.com/nadimkobeissi/16iax10h-linux-sound-saga) and [NixOS Hardware](https://github.com/NixOS/nixos-hardware) |
| VM | A QEMU/KVM Virtual Machine | Needs Virtio Video, 3D Acceleration enabled, OpenGL enabled, and UEFI Firmware with i440FX Chipset |

## TODO List
- [ ] Core
  - [x] Impermanence
  - [x] Backups (very extremely ultra important yes)
  - [x] Disk Encryption
  - [ ] Secure Boot 
  - [x] Pipewire
  - [x] SOPS
  - [x] Network Manager
  - [ ] Moving from `hjem`+`wrappedPrograms` to `home-manager`
    - [ ] Keep the Niri / Noctalia wrappedPrograms
    - [ ] Make a new wrappedProgram for neovim

- [ ] Ricing
  - [ ] Add Stylix
  - [ ] Niri
  - [ ] Noctalia Shell
  - [ ] Fish
  - [ ] Widgets
  - [ ] SDDM
  - [ ] Hotkeys
  - [ ] Kitty
  - [ ] LF

- [ ] Browser Config
  - [x] Firefox (TODO: Remove)
  - [ ] Zen Browser
  - [x] Tor Browser
  - [ ] Helium Browser

- [ ] Editors
  - [ ] Neovim
  - [ ] Zed-Editor
  - [ ] Obsidian

- [ ] Programming Stuff
  - [ ] Nix Flake Templates
    - [ ] Python
    - [ ] NodeJS
    - [ ] Rust
    - [ ] Java
  - [x] Podman
  - [x] Git
  - [x] GitHub CLI

- [ ] Other Things
  - [x] Steam
  - [x] Lutris
  - [x] Minecraft (Prism Launcher)
  - [x] Discord
  - [x] Deltachat
  - [x] VLC
  - [x] KeePassXC
  - [x] Virt Manager
  - [x] KDE Connect
  - [x] Thunderbird
  - [ ] LibreOffice
  - [ ] SyncThing

# References n stuff
Just a general list of shit I saw while I made this
I may/may not be forgetting some
Will keep updating (Hopefully)
- [Vimjoyer's Niri + Noctalia Shell guide](https://youtu.be/aNgujRXDTdE)

- [Saylesss88's Impermanence (BTRFS Encrypted) guide](https://saylesss88.github.io/installation/enc/encrypted_impermanence.html)

  NOTE: The above uses [nix-impermanence](https://github.com/nix-community/impermanence) while this flake uses [nix-preservation](https://github.com/nix-community/preservation)

- [Vimjoyer's Impermanence guide](https://www.youtube.com/watch?v=ZKBSWS7OOb4)

  NOTE: The above uses a tmpfs root while this flake uses a btrfs root subvolume which is nuked on boot via a bootscript

- [Goxore's Nixconf](https://github.com/goxore/nixconf)

- [Iynaix's Dotfiles](https://github.com/iynaix/dotfiles)
