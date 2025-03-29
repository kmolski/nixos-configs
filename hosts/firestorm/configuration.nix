{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/default.nix
      ../../modules/avahi-daemon.nix
      ../../modules/cups-server.nix
      ../../modules/duckdns.nix
      ../../modules/wireguard.nix
    ];

  networking.hostName = "firestorm";

  modules.duckdns.domain = "kmolski";
  modules.wireguard.lanInterface = "end0";

  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/dev/null";
    config = {
      CREATE_ADMIN = pkgs.lib.mkForce "";
      LISTEN_ADDR = "0.0.0.0:8080";
    };
  };
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
  };
  services.postgresqlBackup.enable = true;

  networking.firewall.allowedTCPPorts = [ 8080 ];

  networking.interfaces.end0.ipv4.addresses = [{
    address = "192.168.100.200";
    prefixLength = 24;
  }];
  networking.defaultGateway = "192.168.100.1";
  networking.nameservers = [ "192.168.100.1" ];

  boot.loader.grub.enable = false; # Use the extlinux boot loader.
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.initrd.availableKernelModules = [ "reset-raspberrypi" "pcie-brcmstb" "usbhid" "uas" ];
  hardware.enableRedistributableFirmware = true;

  services.fstrim.enable = true; # Enable SCSI unmap for the external SSD.
  services.udev.extraRules = ''
    ACTION=="add|change", ATTRS{idVendor}=="174c", ATTRS{idProduct}=="55aa", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
