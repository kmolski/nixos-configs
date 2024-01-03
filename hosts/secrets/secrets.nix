let
  users = [];

  firestorm = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+WDpBm2B0VhFyYzzXgV/SzBMpHv4j/XqOBx4l5h/kI" ];
  systems = [ firestorm ];
in
{
  "duckdns-token.age".publicKeys = firestorm;
  "wg-privatekey.age".publicKeys = firestorm;
}
