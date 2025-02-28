{
  inputs = {
    utility.url = "path:///home/work/code/nix-flakes/utility";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      overlays = [ ];
      module = (import ./module.nix);
    in {
      inherit overlays module;
    } // inputs.utility.mkDevShells {
      inherit nixpkgs overlays;
      modules = [
        module
      ];
    };
}