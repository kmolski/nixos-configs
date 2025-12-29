{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    curl
    git
    jaq
    nodePackages.nodejs
    procfd
    python3
    ripgrep
  ];

  users.users.kmolski = {
    shell = pkgs.fish;
    isNormalUser = true;
    initialPassword = "";
    extraGroups = [ "podman" "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKawLwB4U6wWG4vWFGoWZmVmy3sgV9JVbq4AWp0YpE7 kmolski@cloudburst" ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  services.resolved.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
