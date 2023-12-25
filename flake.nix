{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      aurora = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ aurora/configuration.nix ];
      };
      firestorm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ firestorm/configuration.nix ];
      };
    };
  };
}
