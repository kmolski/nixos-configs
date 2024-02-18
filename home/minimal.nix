{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neofetch
  ];

  programs.git = {
    enable = true;
    userName = "kmolski";
    userEmail = "krzysztof.molski29@gmail.com";
    ignores = [ ".direnv" ".envrc" ];
  };

  programs.htop = {
    enable = true;
    settings = {
      fields = with config.lib.htop.fields; [
        PID
        USER
        PRIORITY
        NICE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        NLWP
        M_SIZE
        M_RESIDENT
        STATE
        COMM
      ];
      hide_userland_threads = true;
      detailed_cpu_time = true;
    } // (with config.lib.htop; leftMeters [
      (bar "LeftCPUs")
      (bar "Memory")
      (bar "Swap")
      (text "ZFSARC")
    ]) // (with config.lib.htop; rightMeters [
      (bar "RightCPUs")
      (text "Tasks")
      (text "LoadAverage")
      (text "Uptime")
    ]);
  };

  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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
