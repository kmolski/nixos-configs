let
  cloudburst = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZ8nu/+jgTjV+/QUXXHDaYq+Achcd384zP1cIDCJ9cJ" ];
  firestorm = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+WDpBm2B0VhFyYzzXgV/SzBMpHv4j/XqOBx4l5h/kI" ];
  rainbow = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKOXV2GzMUDEZP2cIwvCkL9O7BIx+sJkUJKjz6Dyb9/" ];
in
{
  "backup-cloudburst-key.age".publicKeys = cloudburst;
  "backup-cloudburst-pass.age".publicKeys = cloudburst;

  "duckdns-token.age".publicKeys = firestorm;
  "wg-privatekey.age".publicKeys = firestorm;

  "letsencrypt-token.age".publicKeys = rainbow;
}
