{ config, lib, ... }:

let
  cfg = config.modules.rabbitmq;
  certs = config.security.acme.certs;
in
{
  config = {
    assertions = [
      {
        assertion = builtins.hasAttr cfg.tlsDomain certs;
        message = "TLS certificate for '${cfg.tlsDomain}' is missing";
      }
    ];

    services.rabbitmq = {
      enable = true;
      plugins = [ "rabbitmq_web_stomp" ];
      configItems =
        let cert = certs."${cfg.tlsDomain}"; in {
          "web_stomp.ssl.port" = toString cfg.wssStompPort;
          "web_stomp.ssl.cacertfile" = "/var/lib/acme/${cert.domain}/chain.pem";
          "web_stomp.ssl.certfile" = "/var/lib/acme/${cert.domain}/cert.pem";
          "web_stomp.ssl.keyfile" = "/var/lib/acme/${cert.domain}/key.pem";
        };
    };

    users.users.rabbitmq.extraGroups = [ "tls-service" ];
    networking.firewall.allowedTCPPorts = [ cfg.wssStompPort ];
  };

  options.modules.rabbitmq = {
    tlsDomain = lib.mkOption {
      type = lib.types.str;
      example = "example.com";
      description = lib.mkDoc ''
        The domain name for TLS certificates.
      '';
    };
    wssStompPort = lib.mkOption {
      type = lib.types.port;
      default = 15673;
      description = lib.mkDoc ''
        The port on which the Web STOMP plugin will listen.
      '';
    };
  };
}
