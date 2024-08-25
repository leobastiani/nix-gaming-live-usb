{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
      lib = nixpkgs.lib;

    in
    {

      nixosConfigurations.isoimage = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./iso.nix
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ];
      };

    };
}
