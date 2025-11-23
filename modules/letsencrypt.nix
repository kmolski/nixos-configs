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
        postRun =
          if config.services.k3s.enable then ''
            k3s kubectl create secret tls default-ingress-cert \
              --namespace=kube-system \
              --key=./key.pem \
              --cert=./cert.pem \
              --save-config \
              --dry-run=client \
              -o yaml | k3s kubectl apply -f -
          '' else "";
        group = "tls-service";
      };
    };

    users.groups.tls-service.members = [ ];

    age.secrets.letsencrypt-token.file = ../hosts/secrets/letsencrypt-token.age;
    age.secrets.letsencrypt-token.owner = config.security.acme.defaults.group;
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
