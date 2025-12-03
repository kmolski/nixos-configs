{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ podman-compose ];

  virtualisation = {
    containers.enable = true;
    podman.enable = true;
    podman.dockerSocket.enable = true;
  };
}
