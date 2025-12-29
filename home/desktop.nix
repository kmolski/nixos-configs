{ config, pkgs, ... }:

{
  imports = [ ./minimal.nix ];

  home.packages = with pkgs; [
    # Internet
    chromium
    firefox
    signal-desktop

    # Productivity
    jetbrains.idea-community
    jetbrains.rust-rover
    libreoffice
    virt-manager

    # Multimedia
    obs-studio
    vlc

    # Fonts
    iosevka
  ];

  programs.zed-editor = {
    enable = true;
    userSettings = {
      vim_mode = true;
      relative_line_numbers = true;
      remove_trailing_whitespace_on_save = true;
      buffer_font_family = "Iosevka";
      buffer_font_size = 16;
      ui_font_family = ".SystemUIFont";
      ui_font_weight = 400;
      ui_font_size = 16;
      theme = {
        mode = "system";
        light = "Gruvbox Light";
        dark = "Gruvbox Dark";
      };
      telemetry.metrics = false;
    };
  };

  programs.gpg = {
    enable = true;
    settings = {
      keyid-format = "long";
      with-fingerprint = true;
      s2k-cipher-algo = "AES256";
      s2k-digest-algo = "SHA512";
      cert-digest-algo = "SHA512";
      throw-keyids = true;
      no-symkey-cache = true;
      require-cross-certification = true;
      personal-cipher-preferences = [ "AES256" "AES192" "AES" ];
      personal-digest-preferences = [ "SHA512" "SHA384" "SHA256" ];
      personal-compress-preferences = [ "ZLIB" "BZIP2" "ZIP" "Uncompressed" ];
      default-preference-list = [ "SHA512" "SHA384" "SHA256" "AES256" "AES192" "AES" "ZLIB" "BZIP2" "ZIP" "Uncompressed" ];
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "AE473752B03BB459" ];
    pinentry.package = pkgs.pinentry-qt;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
}
