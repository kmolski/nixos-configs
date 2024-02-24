{ config, pkgs, ... }:

{
  imports = [ ./minimal.nix ];

  home.packages = with pkgs; [
    chromium
    firefox
    jetbrains.idea-ultimate
    libreoffice
    obs-studio
    spotify
    virt-manager
    vlc
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
}
