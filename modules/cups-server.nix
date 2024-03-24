{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    browsing = true;
    openFirewall = true;
    allowFrom = [ "all" ];
    listenAddresses = [ "*:631" ];
    drivers = [ pkgs.carps-cups ];
  };
}
