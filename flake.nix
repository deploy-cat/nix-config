{
  description = "configstation nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-generators }: {
    packages.x86_64-linux = {
      proxmox-lxc = {
        master = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "proxmox-lxc";
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          modules =
            let
              overlays = [];
              nixos-modules = [];
            in [
              ./modules/base.nix
              ./modules/k8s-master.nix
              {
                nixpkgs.overlays = overlays;
              }
            ] ++ nixos-modules;
        };
        node = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "proxmox-lxc";
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          modules =
            let
              overlays = [];
              nixos-modules = [];
            in [
              ./modules/base.nix
              ./modules/k8s-node.nix
              {
                nixpkgs.overlays = overlays;
              }
            ] ++ nixos-modules;
        };
      };
    };
  };
}
