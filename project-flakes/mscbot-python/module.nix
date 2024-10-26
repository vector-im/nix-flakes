# ci.project-url: https://github.com/matrix-org/mscbot-python
# ci.test-command: ls
{ pkgs, ... }:

{
  # Configure packages to install.
  # Search for package names at https://search.nixos.org/packages?channel=unstable
  packages = with pkgs; [ ];
  
  # Install Python
  languages.python.enable = true;
  languages.python.package = pkgs.python311;

  # Set up postgres with a database called "mscbot"
  services.postgres.enable = true;
  services.postgres.initialDatabases = [
    { name = "mscbot"; }
  ];
}