{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "kmolski";
    userEmail = "krzysztof.molski29@gmail.com";
    signing.key = "8C998FCD276F4328";
    ignores = [ ".direnv" ".envrc" ".idea" ];
  };

  programs.fish.enable = true;
  programs.skim.enable = true;

  programs.home-manager.enable = true;

  home.username = "kmolski";
  home.homeDirectory = "/home/kmolski";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes. See the Home Manager release notes for
  # a list of state version changes in each release.
  home.stateVersion = "23.11";
}
