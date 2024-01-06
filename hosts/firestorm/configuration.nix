{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/default.nix
      ../../modules/avahi-daemon.nix
      ../../modules/wg-server.nix
    ];

  networking.hostName = "firestorm";

  modules.wg-server.lanInterface = "end0";

  systemd.services.duckdns-update = {
    description = "DuckDNS IP update";

    requires = [ "network.target" ];
    startAt = "*:0/5";

    path = [ pkgs.curl ];
    serviceConfig = {
      Type = "simple";
      User = "duckdns";
      Environment = [ "TOKEN_FILE=%d/duckdns-token" ];
      LoadCredential = "duckdns-token:${config.age.secrets.duckdns-token.path}";
    };
    script = ''
      URL="https://www.duckdns.org/update?domains=kmolski&token=$(cat $TOKEN_FILE)"
      CURL_OUT=$(echo url="$URL" | curl --silent --config -)

      if [ $CURL_OUT != "OK" ]; then
        logger -p daemon.err "duckdns update failed"
      fi
    '';
  };
  users.users.duckdns = {
    isSystemUser = true;
    group = "duckdns";
  };
  users.groups.duckdns = { };

  services.postgresql.enable = true;
  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/dev/null";
    config = {
      CREATE_ADMIN = pkgs.lib.mkForce "";
      LISTEN_ADDR = "0.0.0.0:8080";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];

  age.secrets.duckdns-token.file = ../secrets/duckdns-token.age;
  age.secrets.duckdns-token.owner = "duckdns";
  age.secrets.wg-privatekey.file = ../secrets/wg-privatekey.age;

  networking.interfaces.end0.ipv4.addresses = [{
    address = "192.168.100.200";
    prefixLength = 24;
  }];
  networking.defaultGateway = "192.168.100.1";
  networking.nameservers = [ "192.168.100.1" "1.1.1.1" ];

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
