# ci.project-url: https://github.com/matrix-org/sygnal
{
  inputs = {
    utility.url = "path:///home/work/code/nix-flakes/utility";

    # Synapse requires rust, and this overlay allows us to pick a specific rust
    # version.
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      overlays = [ (import inputs.rust-overlay) ];
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