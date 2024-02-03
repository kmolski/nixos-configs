{
  description = "My NixOS configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, agenix, deploy-rs, ... }: {
    nixosConfigurations = {
      aurora = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/aurora/configuration.nix ];
      };
      firestorm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/firestorm/configuration.nix agenix.nixosModules.default ];
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
      };
    };
  };
}
