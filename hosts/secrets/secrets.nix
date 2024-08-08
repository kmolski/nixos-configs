let
  firestorm = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+WDpBm2B0VhFyYzzXgV/SzBMpHv4j/XqOBx4l5h/kI" ];
  rainbow = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKOXV2GzMUDEZP2cIwvCkL9O7BIx+sJkUJKjz6Dyb9/" ];
in
{
  "duckdns-token.age".publicKeys = firestorm;
  "wg-privatekey.age".publicKeys = firestorm;

  "letsencrypt-token.age".publicKeys = rainbow;
}
