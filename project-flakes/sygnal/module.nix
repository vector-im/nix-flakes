{ lib, pkgs, ... }:

{
  # Configure packages to install.
  # Search for package names at https://search.nixos.org/packages?channel=unstable
  packages = with pkgs; [
    openssl
  ];

  # Install Python and manage a virtualenv with Poetry.
  languages.python.enable = true;
  languages.python.poetry.enable = true;
  languages.python.poetry.activate.enable = true;
  languages.python.poetry.install.installRootPackage = true;
  languages.python.poetry.install.enable = true;
  
  tasks."sygnal:patch-python-binaries" = {
    description = "Patch binaries dynamically linked to ld, which will not work on NixOS";
    exec = "${lib.getExe pkgs.patchelf} --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} $VIRTUAL_ENV/bin/ruff";
    
    # wait until ruff is installed first.
    after = [ "devenv:python:poetry" ];
  };
}