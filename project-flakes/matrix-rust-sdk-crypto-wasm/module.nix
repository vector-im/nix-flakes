# ci.project-url: https://github.com/matrix-org/matrix-rust-sdk
# ci.test-command: python -m synapse.app.homeserver --server-name local -c homeserver.yaml --generate-config --report-stats=no
{ pkgs, ... }:

{
  # Configure packages to install.
  # Search for package names at https://search.nixos.org/packages?channel=unstable
  packages = with pkgs; [
    # The rust toolchain and related tools.
    # This will install the "default" profile of rust components.
    # https://rust-lang.github.io/rustup/concepts/profiles.html
    (rust-bin.selectLatestNightlyWith( toolchain: toolchain.default.override {
      # Additionally install the "rust-src" extension to allow diving into the
      # Rust source code in an IDE (rust-analyzer will also make use of it).
      extensions = [ "rust-src" ];
      targets = [ "wasm32-unknown-unknown" "x86_64-unknown-linux-gnu" ];
    }))
    # The rust-analyzer language server implementation.
    rust-analyzer

    # GCC includes a linker; needed for building `ruff`
    gcc
    # Native dependencies for unit tests.
    # openssl
    yarn
  ];

}