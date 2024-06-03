{ config, pkgs, ... }:

{
  imports = [ ./minimal.nix ];

  home.packages = with pkgs; [
    # Web browsers
    chromium
    firefox

    # Productivity
    jetbrains.idea-ultimate
    libreoffice
    virt-manager

    # Multimedia
    obs-studio
    spotify
    vlc

    # Fonts
    iosevka
  ];

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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "AE473752B03BB459" ];
    pinentryPackage = pkgs.pinentry-qt;
  };

  nixpkgs.config.allowUnfree = true;
}
