{ config, pkgs, ... }:

{
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
  };
  networking.enableIPv6 = false;
}
