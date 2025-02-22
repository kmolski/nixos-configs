{ config, lib, pkgs, ... }:

let cfg = config.modules.wireguard;
in {
  config = {
    networking.wg-quick.interfaces.wg0 = {
      peers = [
        { publicKey = "XSiHtvGsEICKN2QrPaRhqRxyH8iUboV8Bk83NEFqsB8="; allowedIPs = [ "192.168.200.2/32" ]; }
        { publicKey = "4kdEOOMekK/pE8kioO+A8rH9LJMUh/yBzTOak9TCpH8="; allowedIPs = [ "192.168.200.3/32" ]; }
      ];
      privateKeyFile = config.age.secrets.wg-privatekey.path;
      address = [ "192.168.200.1/32" ];
      listenPort = cfg.listenPort;
    };

    networking.nat = {
      enable = true;
      internalIPs = [ "192.168.200.0/24" ];
      internalInterfaces = [ "wg0" ];
      externalInterface = cfg.lanInterface;
    };

    networking.firewall.allowedUDPPorts = [ cfg.listenPort ];

    age.secrets.wg-privatekey.file = ../hosts/secrets/wg-privatekey.age;
  };

  options.modules.wireguard = {
    lanInterface = lib.mkOption {
      type = lib.types.str;
      example = "end0";
      description = lib.mkDoc ''
        The name of the local-area network interface.
      '';
    };
    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 51820;
      description = lib.mkDoc ''
        The port on which Wireguard will listen.
      '';
    };
  };
}
