{
  description = "My NixOS configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, agenix, deploy-rs, ... }: {
    nixosConfigurations = {
      cloudburst = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/cloudburst/configuration.nix agenix.nixosModules.default ];
      };
      firestorm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/firestorm/configuration.nix agenix.nixosModules.default ];
      };
      rainbow = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/rainbow/configuration.nix agenix.nixosModules.default ];
      };
    };

    homeConfigurations = {
      minimal-arm = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [ ./home/minimal.nix ];
      };
      desktop = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home/desktop.nix ];
      };
    };

    deploy = {
      user = "root";
      sshUser = "kmolski";
      remoteBuild = true;
      interactiveSudo = true;
      nodes = {
        cloudburst = {
          hostname = "cloudburst.local";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.cloudburst;
          profiles.home.path = deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations.desktop;
          profiles.home.user = "kmolski";
          profiles.home.interactiveSudo = false;
        };
        firestorm = {
          hostname = "firestorm.local";
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.firestorm;
          profiles.home.path = deploy-rs.lib.aarch64-linux.activate.home-manager self.homeConfigurations.minimal-arm;
          profiles.home.user = "kmolski";
          profiles.home.interactiveSudo = false;
        };
        rainbow = {
          hostname = "vps.kmolski.xyz";
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rainbow;
          profiles.home.path = deploy-rs.lib.aarch64-linux.activate.home-manager self.homeConfigurations.minimal-arm;
          profiles.home.user = "kmolski";
          profiles.home.interactiveSudo = false;
        };
      };
    };
  };
}
