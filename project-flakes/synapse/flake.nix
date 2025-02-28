# ci.project-url: https://github.com/element-hq/synapse
{
  inputs = {
    utility.url = "path:///home/work/code/nix-flakes/utility";

    # Synapse requires rust, and this overlay allows us to pick a specific rust
    # version.
    rust-overlay.url = "github:oxalica/rust-overlay";

    # Synapse uses Complement and Sytest as integration test suites. The
    # dependencies needed to run/add/modify tests for these suites is
    # necessary.
    complement.url = "path:///home/work/code/nix-flakes/project-flakes/complement";
    sytest.url = "path:///home/work/code/nix-flakes/project-flakes/sytest";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      overlays = [ (import inputs.rust-overlay) ]
        ++ inputs.complement.overlays
        ++ inputs.sytest.overlays;
      module = (import ./module.nix);
    in {
      inherit overlays module;
    } // inputs.utility.mkDevShells {
      inherit nixpkgs overlays;
      modules = [
        module
        inputs.complement.module
        inputs.sytest.module
      ];
    };
}