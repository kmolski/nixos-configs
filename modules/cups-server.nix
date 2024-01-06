{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    browsing = true;
    allowFrom = [ "all" ];
    listenAddresses = [ "*:631" ];
    drivers = [ pkgs.carps-cups ];
  };

  networking.firewall.allowedTCPPorts = [ 631 ];
  networking.firewall.allowedUDPPorts = [ 631 ];
}
