{ config, pkgs, ... }:

{
  services.fail2ban = {
    enable = true;
    bantime = "1d";
  };
}
