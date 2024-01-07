{ config, lib, pkgs, ... }:

let cfg = config.modules.duckdns-update;
in {
  config = {
    systemd.services.duckdns-update = {
      description = "DuckDNS IP update";

      requires = [ "network.target" ];
      startAt = "*:0/5";

      path = [ pkgs.curl ];
      serviceConfig = {
        Type = "simple";
        User = "duckdns";
        Environment = [ "DUCKDNS_DOMAIN=${cfg.domain}" "TOKEN_FILE=%d/duckdns-token" ];
        LoadCredential = "duckdns-token:${config.age.secrets.duckdns-token.path}";
      };
      script = ''
        URL="https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$(cat $TOKEN_FILE)"
        CURL_OUT=$(echo url="$URL" | curl --silent --config -)

        if [ $CURL_OUT != "OK" ]; then
          logger -p daemon.err "duckdns update failed"
        fi
      '';
    };

    users.users.duckdns = {
      isSystemUser = true;
      group = "duckdns";
    };
    users.groups.duckdns = { };
  };

  options.modules.duckdns-update = {
    domain = lib.mkOption {
      type = lib.types.str;
      example = "subdomain";
      description = lib.mkDoc ''
        The domain name in DuckDNS.
      '';
    };
  };
}
