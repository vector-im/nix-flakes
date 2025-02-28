{
  inputs = {
    utility.url = "path:///home/work/code/nix-flakes/utility";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      overlays = [];
    in rec {
      inherit overlays;
      module = (import ./module.nix);

      devShells = inputs.utility.mkDevShells {
        inherit nixpkgs overlays;
        modules = [
          module
        ];
      };
    };
}