{ config, lib, pkgs, ... }:

let cfg = config.modules.letsencrypt;
in {
  config = {
    security.acme = {
      acceptTerms = true;
      defaults.email = "krzysztof.molski29@gmail.com";
      certs."${cfg.domain}" = {
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        extraDomainNames = [ "*.${cfg.domain}" ];
        credentialFiles = { "CF_DNS_API_TOKEN_FILE" = "${config.age.secrets.letsencrypt-token.path}"; };
        group = "tls-service";
      };
    };

    users.groups.tls-service.members = [ ];
  };

  options.modules.letsencrypt = {
    domain = lib.mkOption {
      type = lib.types.str;
      example = "example.com";
      description = lib.mkDoc ''
        The domain name for Let's Encrypt.
      '';
    };
  };
}
