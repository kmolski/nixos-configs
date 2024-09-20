{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/default.nix
      ../../modules/fail2ban.nix
      ../../modules/kubernetes.nix
      ../../modules/letsencrypt.nix
      ../../modules/rabbitmq.nix
    ];

  networking.hostName = "rainbow";

  modules.letsencrypt.domain = "kmolski.xyz";
  modules.rabbitmq.tlsDomain = "kmolski.xyz";

  networking.interfaces.enp1s0.ipv6.addresses = [{
    address = "2a01:4f8:c012:9c99::1";
    prefixLength = 64;
  }];
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "enp1s0";
  };

  boot.loader.systemd-boot.enable = true; # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  services.fstrim.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
