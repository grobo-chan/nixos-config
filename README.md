## Devices List
All Devices are named after the moons of Jupiter in order of discovery.
(Io was skipped to avoid confusion with I/O (Input/Output))
https://en.wikipedia.org/wiki/Moons_of_Jupiter#List

| Hostname | Device Model  | Status |
| -------- | ------------- | ------ |
| Europa   | Dell Inspiron 15 5000 | Works. Also has the really interesting property of ~~ASPD~~ refusing to let w*ndows work. |
| Ganymede | Lenovo Legion Pro 7 16IAX10H | Works with an audio patch from [here](https://github.com/nadimkobeissi/16iax10h-linux-sound-saga) |
| VM       | A Virtual Machine | Meant to test shit |

## TODO List
- [x] Re-add Ganymede
  - [x] Fix Audio on it
- [ ] System Customisation
    - [ ] Niri
    - [x] Impermanence
    - [x] Backups (very extremely ultra important yes)
    - [ ] Fish
    - [ ] Bar
    - [ ] Widgets
    - [ ] Notification Manager
    - [ ] SDDM
    - [ ] Monitors
    - [ ] Hotkeys
    - [ ] Kitty
    - [ ] LF

- [ ] Browser Config
    - [ ] Zen Browser
    - [ ] Tor Browser
    - [ ] Ungoogled Chromium

- [ ] Editors
    - [ ] Neovim
    - [ ] Zed
    - [ ] Obsidian

- [ ] Programming Stuff
    - [ ] Python
    - [ ] NodeJS
    - [ ] C++
    - [ ] Rust
    - [ ] Java
    - [ ] Docker
    - [x] Git
    - [x] GitHub CLI

- [ ] Other Things
    - [x] Steam
    - [x] Lutris
    - [x] Minecraft (Prism Launcher)
    - [x] Discord
    - [x] Deltachat
    - [x] VLC
    - [ ] LibreOffice
    - [x] KeePassXC
    - [x] Pipewire
    - [x] SOPS
    - [x] Network Manager
    - [ ] DNS
    - [ ] Virt Manager

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
