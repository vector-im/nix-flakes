{ pkgs, ... }:

{
  # Configure packages to install.
  # Search for package names at https://search.nixos.org/packages?channel=unstable
  packages = with pkgs; [
    openssl

    patchelf
    autoPatchelfHook
  ];

  # Install Python and manage a virtualenv with Poetry.
  languages.python.enable = true;
  languages.python.poetry.enable = true;
  # Automatically activate the poetry virtualenv upon entering the shell.
  languages.python.poetry.activate.enable = true;
  languages.python.poetry.install.installRootPackage = true;
  languages.python.poetry.install.enable = true;
  
  tasks = {
    "sygnal:patchpythonbinaries" = {
      description = "Patch binaries dynamically linked to ld, which will not work on NixOS";
      exec = ''
        patchelf --remove-rpath .venv/bin/ruff
        autoPatchelf .venv/bin/ruff
      '';
      after = [ "devenv:enterShell" ];
    };
  };
}