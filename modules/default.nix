{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "pl_PL.UTF-8";

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    curl
    fish
    fzf
    git
    htop
    jq
    lsof
    neofetch
    neovim
    ripgrep
    rlwrap
    rsync
    tmux
    wget
  ];

  users.users.kmolski = {
    shell = pkgs.fish;
    isNormalUser = true;
    initialPassword = "";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFYr/eIDHgmRU3FA+Dj6WySYhk5a3upNJHD8nUi5jk91 krzysztof@aurora"];
    packages = with pkgs; [
    ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  nix.extraOptions = "experimental-features = nix-command flakes";
}
