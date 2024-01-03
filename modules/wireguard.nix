{ config, pkgs, ... }:

{
  networking.wg-quick.interfaces.wg0 = {
    address = [ "192.168.200.1/32" ];
    listenPort = 51820;
    privateKeyFile = config.age.secrets.wg-privatekey.path;
    peers = [
      { publicKey = "XSiHtvGsEICKN2QrPaRhqRxyH8iUboV8Bk83NEFqsB8="; allowedIPs = [ "192.168.200.2/32" ]; }
      { publicKey = "4kdEOOMekK/pE8kioO+A8rH9LJMUh/yBzTOak9TCpH8="; allowedIPs = [ "192.168.200.3/32" ]; }
    ];
  };

  networking.nat = {
    enable = true;
    internalIPs = [ "192.168.200.0/24" ];
    internalInterfaces = [ "wg0" ];
    externalInterface = "end0";
  };
}
