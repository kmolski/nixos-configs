{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/default.nix
      ../../modules/avahi-daemon.nix
    ];

  networking.hostName = "cloudburst";

  services.xserver = {
    enable = true;
    xkb.layout = "pl";
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  boot.loader.systemd-boot.enable = true; # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "elevator=none" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "b682e84e";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
