{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    chromium
    firefox
    jetbrains.idea-ultimate
    libreoffice
    neofetch
    obs-studio
    spotify
    virt-manager
    vlc
  ];

  programs.fish.enable = true;

  home.username = "kmolski";
  home.homeDirectory = "/home/kmolski";
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes. See the Home Manager release notes for
  # a list of state version changes in each release.
  home.stateVersion = "23.11";
}
