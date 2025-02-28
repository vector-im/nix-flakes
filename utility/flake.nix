{
  inputs = {
    # A development environment manager built on Nix. See https://devenv.sh.
    # devenv.url = "github:cachix/devenv/v1.3.1";
    # Needed until https://github.com/cachix/devenv/pull/1573 is in a release.
    devenv.url = "github:cachix/devenv/4b8677f62022e6a235cc4e93a6bbc3d57b77817f";
    # Output a development shell for x86_64/aarch64 Linux/Darwin (MacOS).
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    # `forEachSystem` is a function that simply generates an attribute
    # set with each type of system as the keys, and the attribute set
    # defined below as the value.
    forEachSystem = nixpkgs.lib.genAttrs (import inputs.systems);
  in {
    # We want to build a developer shell for each system type.
    #
    # The result of the code below ends up looking like:
    # outputs = {
    #   devShells = {
    #     x86_64-linux = {
    #       synapse = devenv.lib.mkShell { ... }
    #     };
    #     aarch64-darwin = { ... };
    #     ...
    #   };
    # }
    mkDevShells = {nixpkgs, overlays, modules}:
      rec {
        devShells = forEachSystem (system: {
          default = inputs.devenv.lib.mkShell {
            inherit inputs;
            pkgs = import nixpkgs {
              inherit system nixpkgs overlays;
            };
            modules = [{
              imports = modules;
            }];
          };
        });
        # TODO: Looks like devenv-up doesn't actually check the flake that the devenv
        # is loaded from, but tries to access the flake at ., which is mega lame.
        # Surely this is loading devenv-up into the environment at somewhere accessible?
        packages = forEachSystem (system:
          {
            devenv-up = devShells.${system}.default.config.procfileScript;
          }
        );
        apps = forEachSystem (system:
          {
            default = {
              type = "app";
              program = "devenv-up";
            };
          }
        );
      };
    
    # mkTests = nixpkgs: {
    #   checks = forEachSystem (system: {
    #     packageTest = nixpkgs.stdenv.mkDerivation {
    #       name = "packageTest";

    #       dontUnpack = true;
    #       dontBuild = true;
    #       doCheck = true;
    #       nativeBuildInputs = 
    #     }
    #   })
    # }
  };
}