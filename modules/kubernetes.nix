{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ k3s kubectl ];

  services.k3s = {
    enable = true;
    role = "server";
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];
}
