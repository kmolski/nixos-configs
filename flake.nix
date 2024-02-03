{
  description = "My NixOS configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, agenix, deploy-rs, home-manager, ... }: {
    nixosConfigurations = {
      aurora = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/aurora/configuration.nix ];
      };
      firestorm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/firestorm/configuration.nix agenix.nixosModules.default ];
      };
      cloudburst = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/cloudburst/configuration.nix agenix.nixosModules.default ];
      };
    };

    homeConfigurations = {
      desktop = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home/desktop.nix ];
      };
    };

    deploy = {
      user = "root";
      sshUser = "kmolski";
      sshOpts = [ "-t" ];
      remoteBuild = true;
      magicRollback = false;
      nodes = {
        aurora = {
          hostname = "aurora.local";
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.aurora;
        };
        firestorm = {
          hostname = "firestorm.local";
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.firestorm;
        };
        cloudburst = {
          hostname = "cloudburst.local";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.cloudburst;
        };
      };
    };
  };
}
