{
inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
};
outputs  = {self, nixpkgs,...}:
{
  nixosConfigurations.test-machine =
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =  [
         ./hardware.nix
         ./configuration.nix
      ];
    };
};

}
