# ci.project-url: https://github.com/element-hq/reproduce-rust-licenses
{ pkgs, ... }:

{
  # Configure packages to install.
  # Search for package names at https://search.nixos.org/packages?channel=unstable
  packages = with pkgs; [ ];
  
  # Install Python
  languages.python.enable = true;
  languages.python.package = pkgs.python311;

  # Create a virtualenv with the python test requirements.
  languages.python.venv.enable = true;
  languages.python.venv.requirements = builtins.readFile ((builtins.getEnv "PWD") + "/dev-requirements.txt");
}